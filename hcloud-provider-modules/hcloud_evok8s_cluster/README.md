## Provider Resource: hcloud_evok8s_cluster

A custom resource provider to create a highly available controlplane and workload nodes for EvoK8s Kubernetes.

## Basic Example: Create a highly available Kubernetes Cluster

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-firewall
  namespace: flux-system
spec:
  path: hcloud_evok8s_cluster
  values:
    evok8s_clusters: {
      cluster01: {
        cluster_name: "evok8s-cluster01",
        control_compute_flavor: "cx33",
        control_compute_count: 3,
        worker_compute_flavor: "cx33",
        worker_compute_count: 1,
        MACHINE_IMAGE: "351013422",
        zone_location: "hel1",
        VPC_ID: 11893818,
        vpc_gateway_ip: "10.10.0.1",
        talos_version: "1.11.6",
        k8s_version: "1.34.1"
      }
    }
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  #tfstate:
  #  forceUnlock: "yes"
  #  lockIdentifier: d8bc75bd-c573-42a1-db79-7bc2ab74c556
  retryInterval: 10s
  interval: 15m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-evok8s-cluster-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## Advanced Example: Create multiple highly-available Kubernetes clusters

```yaml
---
apiVersion: infra.contrib.fluxcd.io/v1alpha2
kind: Terraform
metadata:
  name: hcloud-firewall
  namespace: flux-system
spec:
  path: hcloud_evok8s_cluster
  values:
    evok8s_clusters: {
      cluster01: {
        cluster_name: "evok8s-cluster01",
        vm_name_prefix: "evok8s",
        control_compute_flavor: "cx33",
        control_compute_count: 3,
        worker_compute_flavor: "cx33",
        worker_compute_count: 1,
        MACHINE_IMAGE: "351013422",
        zone_location: "hel1",
        VPC_ID: 11893818,
        vpc_gateway_ip: "10.10.0.1",
        talos_version: "1.11.6",
        k8s_version: "1.34.1"
      },
      cluster02: {
        cluster_name: "evok8s-cluster02",
        vm_name_prefix: "evokube",
        control_compute_flavor: "cx33",
        control_compute_count: 3,
        worker_compute_flavor: "cx33",
        worker_compute_count: 1,
        MACHINE_IMAGE: "351013422",
        zone_location: "hel1",
        VPC_ID: 11893818,
        vpc_gateway_ip: "10.10.0.1",
        talos_version: "1.11.6",
        k8s_version: "1.34.1"
      }
    }
  sourceRef:
    kind: OCIRepository
    name: evocloud-tf-modules-hcloud
  approvePlan: auto
  #tfstate:
  #  forceUnlock: "yes"
  #  lockIdentifier: d8bc75bd-c573-42a1-db79-7bc2ab74c556
  retryInterval: 10s
  interval: 15m
  destroyResourcesOnDeletion: true
  writeOutputsToSecret:
    name: hcloud-evok8s-cluster-outputs
    outputs:
  runnerPodTemplate:
    spec:
      envFrom:
        - secretRef:
            name: hcloud-credentials
```

## References

- [Terraform HCLOUD_LOAD_BALANCER](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer)
- [Terraform HCLOUD_LOAD_BALANCER_SERVICE](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_service)
- [Terraform HCLOUD_LOAD_BALANCER_TARGET](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_target)
- [Terraform HCLOUD_LOAD_BALANCER_NETWORK](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_network)
- [Terraform TALOS_MACHINE_SECRETS](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_secrets)
- [Terraform TALOS_CLIENT_CONFIGURATION](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/client_configuration)
- [Terraform TALOS_MACHINE_CONFIGURATION](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/data-sources/machine_configuration)
- [Terraform TALOS_MACHINE_BOOTSTRAP](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_bootstrap)
- [Terraform TALOS_CLUSTER_KUBECONFIG](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/cluster_kubeconfig)

## Authors

Created by the [EvoCloud Engineering Team](https://www.evocloud.dev). Copyright (C) 2026 EvoCloud, Inc.

