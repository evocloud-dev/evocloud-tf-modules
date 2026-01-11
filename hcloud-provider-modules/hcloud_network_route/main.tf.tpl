################################################################################
# HCLOUD_NETWORK_ROUTE Resource
################################################################################
resource "hcloud_network_route" "this" {
  network_id  = var.values.VPC_ID
  destination = var.values.destination_net_cidr
  gateway     = var.values.nat_host_ip
}