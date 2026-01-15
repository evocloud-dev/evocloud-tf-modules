################################################################################
# HCLOUD_SERVER Resource
#############################################################################
resource "hcloud_server" "this" {
  for_each = var.values.hcloud_servers

  name        = each.value.name
  server_type = each.value.compute_flavor
  image       = each.value.machine_image
  location    = each.value.zone_location

  ssh_keys    = ["${each.value.host_ssh_key}"]

  network {
    network_id = each.value.VPC_ID
    ip         = each.value.private_ip
    #There is a bug with Terraform 1.4+ which causes the network to be detached & attached on every apply. Set alias_ips = []
    alias_ips = [] #Bug: https://github.com/hetznercloud/terraform-provider-hcloud/issues/650#issuecomment-1497160625
  }

  #If this block is not defined, two primary (ipv4 & ipv6) ips are auto generated.
  public_net {
    ipv4_enabled = each.value.enable_public_ip ? true : each.value.server_role == "cloudinit-gateway" ? true : false
    ipv6_enabled = false
  }

  {{- if $.Values.hcloud_servers.SECURITY_GROUP_IDS }}
  firewall_ids = each.value.SECURITY_GROUP_IDS
  {{- end }}

  user_data = templatefile (
    each.value.server_role == "cloudinit-gateway" ?
    "${path.module}/templates/cloudinit-gateway.tpl"
    : each.value.server_role == "cloudinit-nat" ?
    "${path.module}/templates/cloudinit-nat.tpl"
    : "${path.module}/templates/no-cloudinit.tpl",
    {
      vpc_cidr = each.value.server_role == "cloudinit-gateway" ? each.value.VPC_CIDR : ""
      vpc_gateway_ip = each.value.server_role == "cloudinit-nat" ? each.value.vpc_gateway_ip : ""
    } #variables to overwrite the template files
  )

  # no space separator in the key or value
  labels = merge(
    {
      "managed-by"  = "EvoCloud"
    },
    {{- if $.Values.hcloud_servers.tags }}
    each.tags
    {{- end }}
  )

  {{- if $.Values.hcloud_servers.enable_delete_protection }}
  delete_protection = each.value.enable_delete_protection
  {{- end }}
}
