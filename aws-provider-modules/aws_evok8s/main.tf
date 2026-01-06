################################################################################
# AWS_INSTANCE Resource
################################################################################
resource "aws_instance" "this" {
  ami                         = var.talos_ami_id
  instance_type               = var.vm_flavor
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = var.vpc_security_group_id

  tags = {
    Name = "evotalos-workstation"
  }

  dynamic "instance_market_options" {
    for_each = var.use_spot ? [1] : []
    content {
      market_type = "spot"
      spot_options {
        instance_interruption_behavior = "stop"
        spot_instance_type = "persistent"
      }
    }
  }
}

#--------------------------------------------------
# Configuring Talos Kubernetes Cluster
#--------------------------------------------------
## Generate machine secrets for Talos Kubernetes Cluster.
resource "talos_machine_secrets" "talos_vm" {}
