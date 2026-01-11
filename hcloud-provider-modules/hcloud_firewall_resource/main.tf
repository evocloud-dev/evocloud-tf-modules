################################################################################
# HCLOUD_FIREWALL Resource
################################################################################
resource "hcloud_firewall" "this" {
  for_each = var.values.security_groups

  name        = each.value.name
  # Ingress rule
  dynamic "rule" {
    for_each = each.value.ingress_rules
    content {
      direction   = "in"
      protocol    = rule.value.protocol
      port        = rule.value.port
      source_ips  = rule.value.source_cidr_blocks
      description = try(rule.value.description, null)
    }
  }

  # Generally Egress rules are not needed in Hetzner,
  # but if there is a need for it we will add it.

  labels = {
    Name  = each.value.name
  }

  lifecycle {
    create_before_destroy = true
  }
}