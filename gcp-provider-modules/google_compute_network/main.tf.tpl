################################################################################
# GOOGLE_COMPUTE_NETWORK Resource
################################################################################
resource "google_compute_network" "this" {
  name                            = var.values.vpc_name
  description                     = "Evocloud Managed Virtual Network"
  routing_mode                    = var.values.vpc_routing_mode # GLOBAL or REGIONAL
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true #In production it is very common to remove the default routes
  {{- if $.Values.custom_mtu }}
  mtu                             = var.values.custom_mtu
  {{- end }}
}