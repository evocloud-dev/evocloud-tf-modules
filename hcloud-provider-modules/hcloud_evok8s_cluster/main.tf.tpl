#--------------------------------------------------
# Set locals for better variable manipulation
#--------------------------------------------------
locals {
  # A flat list of all desired control_plane_nodes
  control_plane_nodes = {
    for cp_node in flatten([
      for k, v in var.values.evok8s_clusters : [
        for i in range(v.control_compute_count) : {
          key           = "${v.vm_name_prefix}-cp0${i + 1}"
          index         = i
          cluster_key   = k
          cluster_data  = v
        }
      ]
    ]) : cp_node.key => cp_node
  }

  # A flat list of all desired worker_nodes
  worker_nodes = {
    for wk_node in flatten([
      for k, v in var.values.evok8s_clusters : [
        for i in range(v.worker_compute_count) : {
          key           = "${v.vm_name_prefix}-wk0${i + 1}"
          index         = i
          cluster_key   = k
          cluster_data  = v
        }
      ]
    ]) : wk_node.key => wk_node
  }

}

################################################################################
# HCLOUD_SERVER Controlplane Resource
#############################################################################
resource "hcloud_server" "controlplane" {
  for_each = local.control_plane_nodes

  name        = each.value.key
  server_type = each.value.cluster_data.control_compute_flavor
  image       = each.value.cluster_data.MACHINE_IMAGE
  location    = each.value.cluster_data.zone_location

  #COMEBACK HERE IF WANT TO SUPPORT PRIVATE SUBNET
  #network {
  #  network_id = each.value.VPC_ID
  #  ip         = each.value.private_ip
  #  #There is a bug with Terraform 1.4+ which causes the network to be detached & attached on every apply. Set alias_ips = []
  #  alias_ips = [] #Bug: https://github.com/hetznercloud/terraform-provider-hcloud/issues/650#issuecomment-1497160625
  #}

  #If this block is not defined, two primary (ipv4 & ipv6) ips are auto generated.
  public_net {
    ipv4_enabled = each.value.cluster_data.enable_public_ip ? true  : false
    ipv6_enabled = false
  }

  # no space separator in the key or value
  labels = merge(
    {
      managed-by  = "EvoCloud"
      cluster = each.value.cluster_key
    },
    {{- if $.Values.evok8s_clusters.tags }}
    each.value.cluster_data.tags
    {{- end }}
  )

  {{- if $.Values.evok8s_clusters.SECURITY_GROUP_IDS }}
  firewall_ids = each.value.SECURITY_GROUP_IDS
  {{- end }}

}

#############################################################################
# HCLOUD_SERVER Worker Resource
#############################################################################
resource "hcloud_server" "worker" {
  for_each = local.worker_nodes

  name        = each.value.key
  server_type = each.value.cluster_data.control_compute_flavor
  image       = each.value.cluster_data.MACHINE_IMAGE
  location    = each.value.cluster_data.zone_location

  #COMEBACK HERE IF WANT TO SUPPORT PRIVATE SUBNET
  #network {
  #  network_id = each.value.VPC_ID
  #  ip         = each.value.private_ip
  #  #There is a bug with Terraform 1.4+ which causes the network to be detached & attached on every apply. Set alias_ips = []
  #  alias_ips = [] #Bug: https://github.com/hetznercloud/terraform-provider-hcloud/issues/650#issuecomment-1497160625
  #}

  #If this block is not defined, two primary (ipv4 & ipv6) ips are auto generated.
  public_net {
    ipv4_enabled = each.value.cluster_data.enable_public_ip ? true  : false
    ipv6_enabled = false
  }

  # no space separator in the key or value
  labels = merge(
    {
      managed-by  = "EvoCloud"
      cluster     = each.value.cluster_key
    },
    {{- if $.Values.evok8s_clusters.tags }}
    each.value.cluster_data.tags
    {{- end }}
  )

  {{- if $.Values.evok8s_clusters.SECURITY_GROUP_IDS }}
  firewall_ids = each.value.SECURITY_GROUP_IDS
  {{- end }}

}

##############################################################################
# Configuring Talos Kubernetes Cluster
##############################################################################
## Generate Talos certs and bootstrap tokens - one per cluster.
resource "talos_machine_secrets" "this" {
  for_each = var.values.evok8s_clusters
}

## Generate the Talos client configuration - one per cluster
data "talos_client_configuration" "this" {
  for_each = var.values.evok8s_clusters

  cluster_name          = each.value.cluster_name
  client_configuration  = talos_machine_secrets.this[each.key].client_configuration
  endpoints = [for xvalue in hcloud_server.controlplane : xvalue.ipv4_address if xvalue.labels.cluster == each.key]
  nodes = concat(
    [for xvalue in hcloud_server.controlplane : xvalue.ipv4_address if xvalue.labels.cluster == each.key],
    [for xvalue in hcloud_server.worker : xvalue.ipv4_address if xvalue.labels.cluster == each.key],
  )
}

#-----------------------------------------------------
## Generate Talos Controlplane Machine Configuration
#-----------------------------------------------------
data "talos_machine_configuration" "controlplane" {
  for_each = var.values.evok8s_clusters

  cluster_name       = each.value.cluster_name
  cluster_endpoint   = "https://${hcloud_server.controlplane["${each.value.vm_name_prefix}-cp01"].ipv4_address}:6443"
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this[each.key].machine_secrets
  talos_version      = each.value.talos_version
  kubernetes_version = each.value.k8s_version
  docs               = false
  examples           = false

  #config_patches = concat(
  #  [for path in var.controlplane_config_patch_files : file(path)]
  #)
  config_patches = [
    yamlencode({
      machine = {
        sysctls = {
          "fs.inotify.max_user_watches" = "1048576"
          "fs.inotify.max_user_instances" = "8192"
          "net.ipv4.neigh.default.gc_thresh1" = "4096"
          "net.ipv4.neigh.default.gc_thresh2" = "8192"
          "net.ipv4.neigh.default.gc_thresh3" = "16384"
          "net.ipv4.tcp_slow_start_after_idle" = "0"
          "user.max_user_namespaces" = "11255"
        }
        network = {
          nameservers = each.value.talos_nameservers
          interfaces = [
            {
              interface = "eth0"
              dhcp      = false
            }
          ]
        }
        certSANs = concat(
          [for xvalue in hcloud_server.controlplane : xvalue.ipv4_address],
          ["127.0.0.1", "localhost"],
        )
        kubelet = {
          extraArgs = {
            cloud-provider = "external"
            rotate-server-certificates = true
          }
          extraConfig = {
            serializeImagePulls = false
            maxParallelImagePulls = 5
            featureGates = {
              UserNamespacesSupport = true
              UserNamespacesPodSecurityStandards = true
            }
            shutdownGracePeriod = "90s"
            shutdownGracePeriodCriticalPods = "15s"
          }
        }
        features = {
          kubernetesTalosAPIAccess = {
            enabled = true
            # https://docs.siderolabs.com/talos/v1.12/security/rbac
            allowedRoles = ["os:reader", "os:etcd:backup"]
            allowedKubernetesNamespaces = ["kube-system"]
          }
        }
        systemDiskEncryption = {
          ephemeral = {
            provider = "luks2"
            keys = [
              {
                nodeID = {}
                slot = 0
              }
            ]
          }
          state = {
            provider = "luks2"
            keys = [
              {
                nodeID = {}
                slot = 0
              }
            ]
          }
        }
      }
      cluster = {
        apiServer = {
          extraArgs = {
            feature-gates = "UserNamespacesSupport=true,UserNamespacesPodSecurityStandards=true"
          }
          certSANs = concat(
            [for xvalue in hcloud_server.controlplane : xvalue.ipv4_address],
            ["127.0.0.1", "localhost"],
          )
        }
        network = {
          cni = {
            name = "none"
          }
          dnsDomain = each.value.cluster_domain
          podSubnets = [each.value.k8s_pod_cidr]
          serviceSubnets = [each.value.k8s_service_cidr]
        }
        proxy = {
          disabled = true
        }
        #A bug with Talos prevents discovery mechanism to work properly: https://github.com/siderolabs/talos/issues/9980
        #https://www.talos.dev/v1.9/talos-guides/discovery/
        discovery = {
          enabled = true
          registries = {
            kubernetes = {
              disabled = false
            }
            service = {
              disabled = true
            }
          }
        }
        //Extra Manifests
        extraManifests = [
          var.values.gateway_api_std,
          var.values.gateway_api_exp,
          var.values.kubelet_serving_cert,
          var.values.kube-metric_server,
          var.values.local-storage_class
        ]
        inlineManifests = [
          {
            name     = "cilium-and-talos-ccm-deploy"
            contents = <<-EOT
              ---
              apiVersion: rbac.authorization.k8s.io/v1
              kind: ClusterRoleBinding
              metadata:
                name: cilium-install
                annotations:
                  ttl.after.delete: "86400s" #Automatically deletes CRB after 24 hours (86400 seconds)
              roleRef:
                apiGroup: rbac.authorization.k8s.io
                kind: ClusterRole
                name: cluster-admin
              subjects:
              - kind: ServiceAccount
                name: cilium-install-sa
                namespace: kube-system
              ---
              apiVersion: v1
              kind: ServiceAccount
              metadata:
                name: cilium-install-sa
                namespace: kube-system
                annotations:
                  ttl.after.delete: "86400s" #Automatically deletes SA after 24 hours (86400 seconds)
              ---
              apiVersion: batch/v1
              kind: Job
              metadata:
                name: cilium-deployer
                namespace: kube-system
              spec:
                backoffLimit: 10
                template:
                  metadata:
                    labels:
                      job: cilium-deployment
                  spec:
                    restartPolicy: OnFailure
                    tolerations:
                      - operator: Exists
                      - effect: NoSchedule
                        operator: Exists
                      - effect: NoExecute
                        operator: Exists
                      - effect: PreferNoSchedule
                        operator: Exists
                      - key: node-role.kubernetes.io/control-plane
                        operator: Exists
                        effect: NoSchedule
                      - key: node-role.kubernetes.io/control-plane
                        operator: Exists
                        effect: NoExecute
                      - key: node-role.kubernetes.io/control-plane
                        operator: Exists
                        effect: PreferNoSchedule
                    affinity:
                      nodeAffinity:
                        requiredDuringSchedulingIgnoredDuringExecution:
                          nodeSelectorTerms:
                            - matchExpressions:
                                - key: node-role.kubernetes.io/control-plane
                                  operator: Exists
                    containers:
                    - name: cilium-install
                      image: alpine/helm:3
                      env:
                      - name: KUBERNETES_SERVICE_HOST
                        valueFrom:
                          fieldRef:
                            apiVersion: v1
                            fieldPath: status.podIP
                      - name: KUBERNETES_SERVICE_PORT
                        value: "6443"
                      command:
                        - sh
                        - -c
                        - |
                          helm upgrade --install --namespace kube-system talos-cloud-controller-manager oci://ghcr.io/siderolabs/charts/talos-cloud-controller-manager -f https://raw.githubusercontent.com/evocloud-dev/evocloud-k8s-manifests/refs/heads/main/talos-ccm-gcp.yaml
                          helm repo add cilium https://helm.cilium.io/
                          helm repo update
                          helm upgrade --install cilium cilium/cilium \
                          --version 1.18.6 \
                          --namespace kube-system \
                          --set k8sServiceHost=localhost \
                          --set k8sServicePort=7445 \
                          --set k8sClientRateLimit.qps=50 \
                          --set k8sClientRateLimit.burst=200 \
                          --set cluster.name=evok8s-hub-cluster \
                          --set cluster.id=0 \
                          --set rollOutCiliumPods=true \
                          --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
                          --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
                          --set l2announcements.enabled=true \
                          --set l2announcements.leaseDuration=15s \
                          --set l2announcements.leaseRenewDeadline=5s \
                          --set l2announcements.leaseRetryPeriod=1s \
                          --set envoyConfig.enabled=true \
                          --set gatewayAPI.enabled=true \
                          --set gatewayAPI.enableAppProtocol=true \
                          --set gatewayAPI.enableAlpn=true \
                          --set-string gatewayAPI.gatewayClass.create=true \
                          --set externalIPs.enabled=true \
                          --set ipam.mode=kubernetes \
                          --set kubeProxyReplacement=true \
                          --set maglev.tableSize=65521 \
                          --set operator.rollOutPods=true \
                          --set cgroup.autoMount.enabled=false \
                          --set cgroup.hostRoot=/sys/fs/cgroup \
                          --set envoy.securityContext.capabilities.envoy="{NET_ADMIN,NET_BIND_SERVICE,PERFMON,BPF}" \
                          --set envoy.securityContext.capabilities.keepCapNetBindService=true
                    serviceAccount: cilium-install-sa
                    serviceAccountName: cilium-install-sa
                    hostNetwork: true
            EOT
          },
          {
            name     = "evocloud-ns"
            contents = <<-EOT
              apiVersion: v1
              kind: Namespace
              metadata:
                name: evocloud-ns
            EOT
          },
          {
            name     = "kubevela-helm-deploy"
            contents = <<-EOT
              ---
              apiVersion: rbac.authorization.k8s.io/v1
              kind: ClusterRoleBinding
              metadata:
                name: kubevela-install
                annotations:
                  ttl.after.delete: "86400s" #Automatically deletes CRB after 24 hours (86400 seconds)
              roleRef:
                apiGroup: rbac.authorization.k8s.io
                kind: ClusterRole
                name: cluster-admin
              subjects:
              - kind: ServiceAccount
                name: vela-install
                namespace: kube-system
              ---
              apiVersion: v1
              kind: ServiceAccount
              metadata:
                name: vela-install
                namespace: kube-system
                annotations:
                  ttl.after.delete: "86400s" #Automatically deletes SA after 24 hours (86400 seconds)
              ---
              apiVersion: batch/v1
              kind: Job
              metadata:
                name: vela-helm-app-deployer
                namespace: kube-system
              spec:
                backoffLimit: 10
                template:
                  metadata:
                    labels:
                      job: vela-deployment
                  spec:
                    containers:
                    - name: helm
                      image: alpine/helm:3
                      command:
                        - sh
                        - -c
                        - |
                          helm repo add kubevela https://kubevela.github.io/charts
                          helm repo update
                          helm upgrade --install kubevela kubevela/vela-core \
                            --namespace vela-system \
                            --create-namespace \
                            --version 1.10.6 \
                            --wait
                    restartPolicy: OnFailure
                    serviceAccount: vela-install
                    serviceAccountName: vela-install
            EOT
          },
          {
            name     = "flux-helm-deploy"
            contents = <<-EOT
              ---
              #Flux Operator Chart Repo: https://github.com/controlplaneio-fluxcd/charts/tree/main/charts/flux-operator
              apiVersion: rbac.authorization.k8s.io/v1
              kind: ClusterRoleBinding
              metadata:
                name: flux-install
                annotations:
                  ttl.after.delete: "86400s" #Automatically deletes CRB after 24 hours (86400 seconds)
              roleRef:
                apiGroup: rbac.authorization.k8s.io
                kind: ClusterRole
                name: cluster-admin
              subjects:
              - kind: ServiceAccount
                name: flux-install
                namespace: kube-system
              ---
              apiVersion: v1
              kind: ServiceAccount
              metadata:
                name: flux-install
                namespace: kube-system
                annotations:
                  ttl.after.delete: "86400s" #Automatically deletes SA after 24 hours (86400 seconds)
              ---
              #https://operatorhub.io/operator/flux-operator
              apiVersion: batch/v1
              kind: Job
              metadata:
                name: flux-operator-deploy
                namespace: kube-system
              spec:
                backoffLimit: 10
                template:
                  metadata:
                    labels:
                      job: flux-operator-deployment
                  spec:
                    containers:
                    - name: helm
                      image: alpine/helm:3
                      command:
                        - sh
                        - -c
                        - |
                          kubectl create namespace flux-system || true
                          helm upgrade --install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
                            --namespace flux-system \
                            --create-namespace \
                            --version 0.40.0 \
                            --wait
                    restartPolicy: OnFailure
                    serviceAccount: flux-install
                    serviceAccountName: flux-install
              ---
              #Deploying Flux Instance with Multi-tenancy Disabled
              apiVersion: fluxcd.controlplane.io/v1
              kind: FluxInstance
              metadata:
                name: flux
                namespace: flux-system
                annotations:
                  fluxcd.controlplane.io/reconcileEvery: "1h"
                  fluxcd.controlplane.io/reconcileArtifactEvery: "15m"
                  fluxcd.controlplane.io/reconcileTimeout: "20m"
              spec:
                distribution:
                  version: "2.7.x"
                  registry: "ghcr.io/fluxcd"
                  artifact: "oci://ghcr.io/controlplaneio-fluxcd/flux-operator-manifests"
                components:
                  - source-controller
                  - kustomize-controller
                  - helm-controller
                  - notification-controller
                  - image-reflector-controller
                  - image-automation-controller
                  - source-watcher
                cluster:
                  type: kubernetes
                  multitenant: false
                  networkPolicy: false
                  domain: "cluster.local"
                kustomize:
                  patches:
                    - target:
                        kind: Deployment
                        name: "(kustomize-controller|helm-controller)"
                      patch: |
                        - op: add
                          path: /spec/template/spec/containers/0/args/-
                          value: --concurrent=10
                        - op: add
                          path: /spec/template/spec/containers/0/args/-
                          value: --requeue-dependency=15s
              ---
              ############################################
              #DEPLOYING TOFU FLUX CONTROLLER
              ############################################
              #Tofu-repo helm repository object
              apiVersion: source.toolkit.fluxcd.io/v1
              kind: HelmRepository
              metadata:
                name: tofu-controller-stable
                namespace: flux-system
              spec:
                interval: 24h
                url: https://flux-iac.github.io/tofu-controller
              ---
              #Tofu-deployment logic
              apiVersion: helm.toolkit.fluxcd.io/v2
              kind: HelmRelease
              metadata:
                name: tofu-controller
                namespace: flux-system
              spec:
                chart:
                  spec:
                    chart: tofu-controller
                    sourceRef:
                      kind: HelmRepository
                      name: tofu-controller-stable
                    version: ">=0.16.0-rc.8"
                interval: 1h0s
                releaseName: tofu-controller
                targetNamespace: flux-system
                install:
                  crds: Create
                  remediation:
                    retries: 3
                upgrade:
                  crds: CreateReplace
                  remediation:
                    retries: 3
                driftDetection:
                  mode: enabled
                values:
                  runner:
                    grpc:
                      maxMessageSize: 30
                  replicaCount: 1
                  resources:
                    requests:
                      cpu: 500m
                      memory: 256Mi
                    limits:
                      memory: 1Gi
                  caCertValidityDuration: 24h
                  certRotationCheckFrequency: 60m
              ---
            EOT
          },
          {
            name     = "kubevela-UI-deploy"
            contents = <<-EOT
              ---
              apiVersion: rbac.authorization.k8s.io/v1
              kind: ClusterRoleBinding
              metadata:
                name: kubevela-ui-install
                annotations:
                  ttl.after.delete: "86400s" #Automatically deletes CRB after 24 hours (86400 seconds)
              roleRef:
                apiGroup: rbac.authorization.k8s.io
                kind: ClusterRole
                name: cluster-admin
              subjects:
              - kind: ServiceAccount
                name: vela-ui-install
                namespace: kube-system
              ---
              apiVersion: v1
              kind: ServiceAccount
              metadata:
                name: vela-ui-install
                namespace: kube-system
                annotations:
                  ttl.after.delete: "86400s" #Automatically deletes SA after 24 hours (86400 seconds)
              ---
              apiVersion: batch/v1
              kind: Job
              metadata:
                name: vela-ui-addon-deployer
                namespace: kube-system
              spec:
                backoffLimit: 10
                template:
                  metadata:
                    labels:
                      job: vela-ui-deployment
                  spec:
                    containers:
                    - name: velacli
                      image: ghcr.io/evocloud-dev/oci/kubevela-cli:1.10.6-amd64
                      command:
                        - "vela"
                      args:
                        - "addon"
                        - "enable"
                        - "velaux"
                        - "serviceType=NodePort"
                        - "nodePort=30000"
                    restartPolicy: OnFailure
                    serviceAccount: vela-ui-install
                    serviceAccountName: vela-ui-install
            EOT
          },
        ]
      }
    }),
  ]
}

#-----------------------------------------------------
## Generate Talos Worker Machine Configuration
#-----------------------------------------------------
data "talos_machine_configuration" "worker" {
  for_each = var.values.evok8s_clusters

  cluster_name       = each.value.cluster_name
  cluster_endpoint   = "https://${hcloud_server.controlplane["${each.value.vm_name_prefix}-cp01"].ipv4_address}:6443"
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.this[each.key].machine_secrets
  talos_version      = each.value.talos_version
  kubernetes_version = each.value.k8s_version
  docs               = false
  examples           = false

  #config_patches = concat(
  #  [for path in var.worker_config_patch_files : file(path)]
  #)
  config_patches = [
    yamlencode({
      machine = {
        network = {
          nameservers = each.value.talos_nameservers
        }
        kubelet = {
          extraArgs = {
            cloud-provider = "external"
            rotate-server-certificates = true
          }
        }
        install = {
          extraKernelArgs = ["talos.dashboard.disabled=1"]
        }
        systemDiskEncryption = {
          ephemeral = {
            provider = "luks2"
            options = ["no_read_workqueue", "no_write_workqueue"]
            keys = [
              {
                nodeID = {}
                slot = 0
              }
            ]
          }
          state = {
            provider = "luks2"
            options = ["no_read_workqueue", "no_write_workqueue"]
            keys = [
              {
                nodeID = {}
                slot = 0
              }
            ]
          }
        }
      }
      cluster = {
        network = {
          cni = {
            name = "none"
          }
          dnsDomain = each.value.cluster_domain
          podSubnets = [each.value.k8s_pod_cidr]
          serviceSubnets = [each.value.k8s_service_cidr]
        }
      }
    }),
  ]
}

#-----------------------------------------------------
# Apply Talos Controlplane Machine Configuration
#-----------------------------------------------------
## Give time for controlplane nodes readiness
resource "time_sleep" "timer" {
  create_duration = "30s"
  depends_on = [hcloud_server.controlplane, data.talos_machine_configuration.controlplane]
}

## Apply Talos Machine Configuration to controlplane nodes
resource "talos_machine_configuration_apply" "controlplane" {
  for_each                    = hcloud_server.controlplane
  depends_on                  = [time_sleep.timer]

  client_configuration        = talos_machine_secrets.this[each.value.labels.cluster].client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane[each.value.labels.cluster].machine_configuration
  endpoint                    = each.value.ipv4_address
  node                        = each.value.ipv4_address
}

#-----------------------------------------------------
# Apply Talos Worker Machine Configuration
#-----------------------------------------------------
resource "talos_machine_configuration_apply" "worker" {
  for_each                    = hcloud_server.worker
  depends_on                  = [talos_machine_configuration_apply.controlplane]

  client_configuration        = talos_machine_secrets.this[each.value.labels.cluster].client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[each.value.labels.cluster].machine_configuration
  endpoint                    = each.value.ipv4_address
  node                        = each.value.ipv4_address
}

#---------------------------------------------------------
# Start the bootstraping of the Talos Kubernetes Cluster
#---------------------------------------------------------
## Avoid race condition between talos_machine_configuration_apply and bootstrapping
resource "time_sleep" "timer2" {
  create_duration = "30s"
  depends_on = [talos_machine_configuration_apply.controlplane]
}

## Bootstrapping is only done on one Controlplane node
resource "talos_machine_bootstrap" "this" {
  for_each                   = var.values.evok8s_clusters
  depends_on                 = [talos_machine_configuration_apply.controlplane, time_sleep.timer2]

  client_configuration       = talos_machine_secrets.this[each.key].client_configuration
  endpoint                   = hcloud_server.controlplane["${each.value.vm_name_prefix}-cp01"].ipv4_address
  node                       = hcloud_server.controlplane["${each.value.vm_name_prefix}-cp01"].ipv4_address
  timeouts                   = { create = "5m" }
}

## Collect the Talos Kubeconfig
resource "talos_cluster_kubeconfig" "kubeconfig" {
  for_each                  = var.values.evok8s_clusters
  depends_on                = [ talos_machine_bootstrap.this ]

  client_configuration = talos_machine_secrets.this[each.key].client_configuration
  endpoint             = hcloud_server.controlplane["${each.value.vm_name_prefix}-cp01"].ipv4_address
  node                 = hcloud_server.controlplane["${each.value.vm_name_prefix}-cp01"].ipv4_address
}
