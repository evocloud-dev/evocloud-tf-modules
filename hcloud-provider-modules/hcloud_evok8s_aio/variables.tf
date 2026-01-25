variable "values" {
  type = object({
    evok8s_aio    = optional(map(object({
      cluster_name        = string
      cluster_domain      = optional(string, "cluster.local")
      talos_version       = string
      talos_nameservers   = optional(list(string), ["185.12.64.1", "185.12.64.2"]) #hetzner nameservers
      k8s_version         = string
      k8s_pod_cidr        = optional(string, "10.244.0.0/16")
      k8s_service_cidr    = optional(string, "10.96.0.0/12")
      vm_name             = string
      compute_flavor      = string
      MACHINE_IMAGE       = string
      zone_location       = string
      SECURITY_GROUP_IDS  = optional(list(string))
      #vpc_gateway_ip      = optional(string)
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

  # Variables validation
  validation {
    condition = length(distinct([for evok8s in var.values.evok8s_aio : evok8s.vm_name ])) == length(var.values.evok8s_aio)
    error_message = "Cluster must have a unique vm_name."
  }

  validation {
    condition = length(distinct([for evok8s in var.values.evok8s_aio : evok8s.cluster_name ])) == length(var.values.evok8s_aio)
    error_message = "Cluster must have a unique cluster_name."
  }

  validation {
    condition = alltrue([
      for evok8s in var.values.evok8s_aio : contains([
        "fsn1", "nbg1", "hel1", "ash", "hil", "sin"
      ], evok8s.zone_location)
    ])
    error_message = "zone_location must be one of: 'fsn1' (Falkenstein), 'nbg1' (Nuremberg), 'hel1' (Helsinki), 'ash' (Ashburn), 'hil' (Hillsboro), 'sin' (Singapore)."
  }

}
