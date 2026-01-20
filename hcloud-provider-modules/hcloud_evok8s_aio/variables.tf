variable "values" {
  type = object({
    evok8s_aio    = optional(map(object({
      cluster_name        = string
      talos_version       = string
      k8s_version         = string
      k8s_pod_cidr        = optional(string, "10.244.0.0/16")
      k8s_service_cidr    = optional(string, "10.96.0.0/12")
      k8s_dns_domain      = optional(string, "cluster.local")
      vm_name             = string
      compute_flavor      = string
      machine_image       = string
      zone_location       = string
      #VPC_ID          = number
      #VPC_CIDR        = optional(string)
      #vpc_gateway_ip  = optional(string)
      #SECURITY_GROUP_IDS  = optional(list(string))
      #private_ip          = optional(string)
      enable_public_ip    = optional(bool, true)
      tags                = optional(map(string))
    })))

    gateway_api_std       = optional(string, "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml")
    gateway_api_exp       = optional(string, "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/experimental-install.yaml")
    kubelet_serving_cert  = optional(string, "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml")
    kube-metric_server    = optional(string, "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml")
    local-storage_class   = optional(string, "https://raw.githubusercontent.com/evocloud-dev/evocloud-k8s-manifests/refs/heads/main/local-storageclass.yaml")

  })

}
