#--------------------------------------------------
# Set locals for better variable manipulation
#--------------------------------------------------
locals {
  k8s_api_port = 6443

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

#--------------------------------------------------
# EvoCloud Namespace
#--------------------------------------------------
locals {
  evocloud_namespace_manifest = {
    name = "evocloud-namespace"
    contents = yamlencode({
      apiVersion = "v1"
      kind       = "Namespace"
      metadata = {
        name      = "evocloud-ns"
      }
    })
  }
}