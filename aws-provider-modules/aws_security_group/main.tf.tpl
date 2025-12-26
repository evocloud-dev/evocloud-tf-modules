################################################################################
# AWS_SECURITY_GROUP Resource
################################################################################
resource "aws_security_group" "this" {
  for_each = var.values.security_groups

  vpc_id      = var.values.VPC_ID
  name        = each.value.name
  description = each.value.description

  # Ingress rules
  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      self        = ingress.value.self
      description = ingress.value.description
    }
  }

  # Egress rules
  dynamic "egress" {
    for_each = each.value.egress_rules != null && length(each.value.egress_rules) > 0 ? each.value.egress_rules : (
      var.values.enable_default_egress ? [{
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow all outbound (default)"
      }] : []
    )

    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = {
    Name  = each.value.name
  }

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# AWS_SECURITY_GROUP Resource
################################################################################
# Later in here we will add the logic to alter an existing AWS_SECURITY_GROUP