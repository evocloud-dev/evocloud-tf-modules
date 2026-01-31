variable "values" {
  type = object({
    evok8s_clusters           = optional(map(object({
      cluster_name            = string
      cluster_domain          = optional(string, "cluster.local")
      talos_version           = string
      talos_nameservers       = optional(list(string), ["185.12.64.1", "185.12.64.2"]) #hetzner nameservers
      k8s_version             = string
      k8s_pod_cidr            = optional(string, "10.244.0.0/16")
      k8s_service_cidr        = optional(string, "10.96.0.0/12")
      vm_name_prefix          = optional(string, "evok8s")
      MACHINE_IMAGE           = string
      worker_compute_count    = number
      worker_compute_flavor   = string
      control_compute_flavor  = string
      control_compute_count   = number
      enable_public_ip        = optional(bool, true)#COMEBACK TO THIS
      zone_location           = string
      SECURITY_GROUP_IDS      = optional(list(string))
      tags                    = optional(map(string))
    })))

    gateway_api_std       = optional(string, "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml")
    gateway_api_exp       = optional(string, "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/experimental-install.yaml")
    kubelet_serving_cert  = optional(string, "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml")
    kube-metric_server    = optional(string, "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml")
    local-storage_class   = optional(string, "https://raw.githubusercontent.com/evocloud-dev/evocloud-k8s-manifests/refs/heads/main/local-storageclass.yaml")

  })

  #Variable validation logic
  validation {
    condition = length(distinct([for evok8s in var.values.evok8s_clusters : evok8s.cluster_name ])) == length(var.values.evok8s_clusters)
    error_message = "EvoK8s Clusters must have a unique cluster_name."
  }

  validation {
    condition = alltrue([
      for evok8s in var.values.evok8s_clusters : contains([
        "fsn1", "nbg1", "hel1", "ash", "hil", "sin"
      ], evok8s.zone_location)
    ])
    error_message = "zone_location must be one of: 'fsn1' (Falkenstein), 'nbg1' (Nuremberg), 'hel1' (Helsinki), 'ash' (Ashburn), 'hil' (Hillsboro), 'sin' (Singapore)."
  }

  validation {
    condition     = alltrue([for evok8s in var.values.evok8s_clusters : evok8s.control_compute_count <= 5 ])
    error_message = "Controlplane nodes (control_compute_count) should not exceed 5."
  }

  validation {
    condition     = alltrue([for evok8s in var.values.evok8s_clusters : evok8s.control_compute_count % 2 == 1 ])
    error_message = "Controlplane nodes count (compute_compute_count) must be an odd number(1, 3, or 5) to prevent a split-brain scenario."
  }

  validation {
    condition     = alltrue([for evok8s in var.values.evok8s_clusters : evok8s.worker_compute_count <= 99 ])
    error_message = "Worker nodes (worker_compute_count) should not exceed 99."
  }
}
