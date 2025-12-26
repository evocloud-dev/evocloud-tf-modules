#--------------------------------------------------
# Expose AWS_SECURITY_GROUP Attributes
#--------------------------------------------------

output "security_group_ids" {
  description = "Map of Security Group Name => Security Group ID"
  value       = {
    for k, v in aws_security_group.this : k => v.id
  }
}
