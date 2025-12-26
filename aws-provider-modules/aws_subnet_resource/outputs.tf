#--------------------------------------------------
# Expose AWS_SUBNET Attributes
#--------------------------------------------------

output "subnet_ids" {
  description = "Map of All Subnet Name => Subnet ID"
  value       = {
    for k, v in aws_subnet.this : k => v.id
  }
}

output "public_subnet_ids" {
  description = "Map of only Public Subnet Name => Subnet ID"
  value       = {
    for k, v in aws_subnet.this : k => v.id if v.tags["NetworkTier"] == "public"
  }
}

output "private_subnet_ids" {
  description = "Map of only Private Subnet Name => Subnet ID"
  value       = {
    for k, v in aws_subnet.this : k => v.id if v.tags["NetworkTier"] == "private"
  }
}

output "subnet_cidrs" {
  description = "Map of All Subnet Name => CIDR Block"
  value       = {
    for k, v in aws_subnet.this : k => v.cidr_block
  }
}

output "public_subnet_cidrs" {
  description = "Map of only Public Subnet Name => CIDR Block"
  value       = {
    for k, v in aws_subnet.this : k => v.cidr_block if v.tags["NetworkTier"] == "public"
  }
}

output "private_subnet_cidrs" {
  description = "Map of only Private Subnet Name => CIDR Block"
  value       = {
    for k, v in aws_subnet.this : k => v.cidr_block if v.tags["NetworkTier"] == "private"
  }
}

output "subnet_arns" {
  description = "Map of Subnet Name => ARN of the Subnet"
  value       = {
    for k, v in aws_subnet.this : k => v.arn
  }
}