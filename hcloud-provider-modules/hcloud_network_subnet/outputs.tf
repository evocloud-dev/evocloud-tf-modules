#--------------------------------------------------
# Expose HCLOUD_NETWORK_SUBNET Attributes
#--------------------------------------------------

output "subnet_ids" {
  description = "Map of All Subnet Name => Subnet ID"
  value       = {
    for k, v in hcloud_network_subnet.this : k => v.id
  }
}

output "subnet_cidrs" {
  description = "Map of All Subnet Name => CIDR Block"
  value       = {
    for k, v in hcloud_network_subnet.this : k => v.ip_range
  }
}