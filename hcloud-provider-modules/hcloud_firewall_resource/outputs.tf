#--------------------------------------------------
# Expose HCLOUD_FIREWALL Attributes
#--------------------------------------------------

output "security_group_ids" {
  description = "Map of Security Group Name => Security Group ID"
  value       = {
    for k, v in hcloud_firewall.this : k => v.id
  }
}