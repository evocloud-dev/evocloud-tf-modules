#--------------------------------------------------
# Expose HCLOUD_SERVER Attributes
#--------------------------------------------------

output "server_ids" {
  description = "Map of Server Name => Server ID"
  value       = {
    for k, v in hcloud_server.this : k => v.id
  }
}

output "server_private_ips" {
  description = "Map of Server Name => Server Private IP"
  value       = {
    for k, v in hcloud_server.this : k => v.network[*].ip
  }
}

output "server_public_ips" {
  description = "Map of Server Name => Server Public IP"
  value       = {
    for k, v in hcloud_server.this : k => v.ipv4_address
    if length(v.ipv4_address) > 0
  }
}
