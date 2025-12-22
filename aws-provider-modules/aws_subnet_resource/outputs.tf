#--------------------------------------------------
# Expose AWS_SUBNET Attributes
#--------------------------------------------------

output "subnet_ids" {
  description = "Map of Subnet Name => Subnet ID"
  value       = {
    for k, v in aws_subnet.this : k => v.id
  }
}

output "subnet_cidrs" {
  description = "Map of Subnet Name => CIDR Block"
  value       = {
    for k, v in aws_subnet.this : k => v.cidr_block
  }
}

output "subnet_arns" {
  description = "Map of Subnet Name => ARN of the Subnet"
  value       = {
    for k, v in aws_subnet.this : k => v.arn
  }
}