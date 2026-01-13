#--------------------------------------------------
# Local for cloud-init content
#--------------------------------------------------
locals {
  cloudinit_tpl_path = {
    "nat-gateway-vm"    = "${path.module}/templates/gateway-vm.yaml.tpl"
    "nat-private-vm"    = "${path.module}/templates/private-vm.yaml.tpl"
    "minimal-base-vm"   = "${path.module}/templates/base-vm.yaml.tpl"
  }
}

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
    ipv4_enabled = each.value.enable_public_ip
    ipv6_enabled = false
  }


  {{- if $.Values.hcloud_servers.SECURITY_GROUP_IDS }}
  firewall_ids = each.value.SECURITY_GROUP_IDS
  {{- end }}

  {{- if $.Values.hcloud_servers.host_user_data_tpl }}
  user_data = templatefile(local.cloudinit_tpl_path[each.value.server_role], {
    var1 = something
    var2 = something
  })
  {{- end }}

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
