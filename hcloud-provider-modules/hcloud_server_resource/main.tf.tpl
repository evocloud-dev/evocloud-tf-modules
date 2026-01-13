#--------------------------------------------------
# Local for cloud-init content
#--------------------------------------------------
locals {
  cloud_init_gateway = <<-EOF
    #cloud-config
    packages:
      - iptables
      - iptables-services

    write_files:
      - path: /etc/NetworkManager/dispatcher.d/ifup-local
        content: |
          #!/bin/sh

          /bin/echo 1 > /proc/sys/net/ipv4/ip_forward
          /sbin/iptables -t nat -A POSTROUTING -s '10.0.0.0/16' -o eth0 -j MASQUERADE
        permissions: '0755'

    runcmd:
      - reboot
  EOF

  cloud_init_nat_vm = <<-EOF
     #cloud-config
     write_files:
       - path: /etc/NetworkManager/dispatcher.d/ifup-local
         content: |
           #!/bin/sh

           nm-online -q --timeout=30
           if ! ip route show default | grep -q "via 10.0.0.1"; then
             /sbin/ip route add default via 10.0.0.1
           fi
         permissions: '0755'

       - path: /etc/systemd/resolved.conf
           content: |
             [Resolve]
             DNS=185.12.64.2 185.12.64.1
             FallbackDNS=8.8.8.8
           append: true

     runcmd:
       - dnf remove -y hc-utils
       - reboot
  EOF
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

  {{- if $.Values.hcloud_servers.enable_gateway_config }}
  user_data = local.cloud_init_gateway
  {{- else }}
  user_data = local.cloud_init_nat_vm
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
