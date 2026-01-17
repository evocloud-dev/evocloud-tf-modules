terraform {
  required_providers {
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}
################################################################################
# HCLOUD Talos AMI Resource
#############################################################################

resource "hcloud_server" "talos_ami_builder" {
  name        = "talos-ami-builder-v${var.values.talos_version}"
  server_type = var.values.compute_flavor
  image       = var.values.machine_image
  location    = var.values.zone_location

  rescue      = "linux64" #rescue mode needed to overwrite the base image
  ssh_keys = [] #no ssh keys needed since we are in rescue mode

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  provisioner "remote-exec" {
    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      timeout     = "10m"
    }

    inline = [
      "apt-get update && apt-get install -y wget xz-utils",
      "cd /tmp && wget https://factory.talos.dev/image/${var.values.talos_schematic_id}/${var.values.talos_version}/hcloud-amd64.raw.xz",
      "xz -d -c hcloud-amd64.raw.xz | dd of=/dev/sda bs=4M status=progress && sync",
      "shutdown -h now"
    ]
  }
}

resource "time_sleep" "timer" {
  create_duration = "60s"
}

#Create AMI from Instance Snapshot
resource "hcloud_snapshot" "talos_ami" {
  depends_on = [time_sleep.timer]

  server_id = hcloud_server.talos_ami_builder.id

  description = "TalosLinux-v${var.values.talos_version}-amd64"
  labels = {
    "managed-by" = "EvoCloud"
    "os"          = "TalosLinux"
    "arch"        = "amd64"
  }
}