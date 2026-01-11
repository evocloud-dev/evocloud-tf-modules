################################################################################
# HCLOUD_NETWORK_SUBNET Resource
################################################################################

# Set locals for better variable manipulation
locals {
  # A flat list of all desired subnets
  subnets = flatten([
    for subnet in var.values.subnets_configs : {
        key           = "${subnet.subnet_name}-${subnet.network_zone}"
        subnet_name   = subnet.subnet_name
        network_tier  = subnet.network_tier
        avail_zone    = subnet.network_zone
        subnet_num    = subnet.subnet_number
        subnet_bits   = subnet.subnet_newbits
    }
  ])
  # Convert local.subnets to a map for for_each
  subnet_map = {
    for s in local.subnets : s.key => s
  }
}

# Dynamically create hcloud_network_subnets
resource "hcloud_network_subnet" "this" {
  for_each      = local.subnet_map

  network_id    = var.values.VPC_ID
  ip_range      = cidrsubnet(var.values.VPC_CIDR_BLOCK, each.value.subnet_bits, each.value.subnet_num)
  network_zone  = each.value.avail_zone
  type          = each.value.network_tier # server | cloud | vswitch
}