#--------------------------------------------------
# Expose HCLOUD_NETWORK_ROUTE Attributes
#--------------------------------------------------

output "network_route_id" {
  description = "Hetzner Network Route ID"
  value       = try(hcloud_network_route.this.id, null)
}