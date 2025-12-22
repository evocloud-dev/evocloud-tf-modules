################################################################################
# AWS_SUBNET Resource
################################################################################

# Fetch Available AZs in the current region
data "aws_availability_zones" "available" {
  state = "available"
}

# Set locals for better variable manipulation
locals {
  # We want to use exactly 3 AZs (Most regions have at least 3)
  azs = slice(sort(data.aws_availability_zones.available.names), 0, 3)
  # A flat list of all desired subnets
  subnets = flatten([
    for subnet in var.values.desired_subnet_names : [
      for idx, az in local.azs : {
        key = "${subnet}-${az}"
        subnet_name = subnet
        avail_zone = az
        az_index = idx #0, 1, 2
        subnet_num = var.values.subnet_number[subnet] + idx
      }
    ]
  ])
  # Convert local.subnets to a map for for_each
  subnet_map = {
    for s in local.subnets : s.key => s
  }
}

# Dynamically create AWS_SUBNET in all 3 Availability Zones
resource "aws_subnet" "this" {
  for_each = local.subnet_map

  vpc_id     = var.values.VPC_ID
  cidr_block = cidrsubnet(var.values.VPC_CIDR_BLOCK, var.values.subnet_newbits, each.value.subnet_num)
  availability_zone = each.value.avail_zone

  tags = {
    Name = each.key
  }

  #Resource Lifecycle Management
  {{- if $.Values.lifecycle }}
  lifecycle {
    {{- if $.Values.lifecycle.create_before_destroy }}
    create_before_destroy   = {{ $.Values.lifecycle.create_before_destroy }}
    {{- end }}

    {{- if $.Values.lifecycle.ignore_changes }}
    prevent_destroy         = {{ $.Values.lifecycle.prevent_destroy }}
    {{- end }}

    {{- if $.Values.lifecycle.ignore_changes }}
    ignore_changes          = {{ $.Values.lifecycle.ignore_changes }}
    {{- end }}
  }
  {{- end }}
}