#--------------------------------------------
# Associate AWS_VPC_DHCP_OPTIONS to AWS_VPC
#--------------------------------------------
#Lookup Base AMI
# Talos AMI Owner ID: 540369536782 (Official Sidero Labs / talos Account)
data "aws_ami" "this" {
  most_recent = true
  owners = [var.ami_owner_id]

  filter {
    name = "name"
    values = ["${var.ami_name_param}-${var.ami_image_version}-*"]
  }
  filter {
    name = "architecture"
    values = [var.ami_image_arch]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

################################################################################
# AWS_AMI_COPY Resource
################################################################################
# The "AMI copy" resource allows duplication of an Amazon Machine Image (AMI),
# including cross-region copies.
resource "aws_ami_copy" "this" {
  name              = "evoami-${var.ami_name_param}-${var.ami_image_version}-${var.ami_image_arch}"
  description       = "Custom Built AMI - ${var.ami_name_param}-${var.ami_image_version}"
  source_ami_id     = data.aws_ami.this.id
  source_ami_region = var.ami_image_region

  tags = {
    Name          = "evoami-${var.ami_name_param}-${var.ami_image_version}-${var.ami_image_arch}"
    Architecture  = "${var.ami_image_arch}"
    CreatedBy     = "EvoCloud"
  }
}