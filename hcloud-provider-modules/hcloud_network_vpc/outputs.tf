#--------------------------------------------------
# Expose HCLOUD_NETWORK Attributes
#--------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(hcloud_network.this.id, null)
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = try(hcloud_network.this.name, null)
}

output "vpc_ip_range" {
  description = "IPv4 Prefix of the whole Network"
  value       = try(hcloud_network.this.ip_range, null)
}