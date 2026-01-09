################################################################################
# HETZNER VPC Network Resource
################################################################################
resource "hcloud_network" "this" {
  name        = var.values.vpc_name
  ip_range    = var.values.cidr_block
  {{- if $.Values.labels }}
  labels      = var.values.labels
  {{- end }}
}