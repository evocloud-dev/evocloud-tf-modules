#--------------------------------------------------
# Expose HCLOUD EvoK8S Cluster Resource Information
#--------------------------------------------------

output "kubeconfigs" {
  description = "Map value of each  evok8s kubeconfig"
  value       = {
    for k, v in var.values.evok8s_clusters : k => talos_cluster_kubeconfig.kubeconfig[k].kubeconfig_raw
  }
  sensitive   = true
}

# Retrieve the Talos Configuration in case you would like to interact with the `talosctl`
output "talosconfigs" {
  description = "Map value of each evok8s talosconfig"
  value       = {
    for k, v in var.values.evok8s_clusters : k => data.talos_client_configuration.this[k].talos_config
  }
  sensitive   = true
}

# Retrieve the Talos Client Configuration of the Talos Kubernetes Cluster
output "talos_client_configs" {
  description = "Map value of each evok8s Talos client/Worker Configuration"
  value     = {
    for k, v in var.values.evok8s_clusters : k => data.talos_client_configuration.this[k].client_configuration
  }
  sensitive = true
}

# Retrieve Talos Machine Configuration for Controlplane
output "talos_controlplane_configs" {
  description = "Map value of each evok8s Talos Controlplane Machine Configuration"
  value = {
    for k, v in var.values.evok8s_clusters : k => data.talos_machine_configuration.controlplane[k].machine_configuration
  }
  sensitive = true
}

# Retrieve Talos Machine Configuration for Worker
output "talos_worker_configs" {
  description = "Map value of each evok8s Talos Worker Machine Configuration"
  value = {
    for k, v in var.values.evok8s_clusters : k => data.talos_machine_configuration.worker[k].machine_configuration
  }
  sensitive = true
}