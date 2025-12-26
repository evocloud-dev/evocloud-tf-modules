#--------------------------------------------------
# Expose AWS_GATEWAY Attributes
#--------------------------------------------------

output "public_rt_id" {
  description = "Public Route table ID"
  value       = try(aws_route_table.public_rt.id, null)
}

output "private_rt_id" {
  description = "Private Route table ID"
  value       = try(aws_route_table.private_rt.id, null)
}