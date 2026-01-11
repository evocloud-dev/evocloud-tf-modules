#--------------------------------------------------
# Supported Cloud Provider
#--------------------------------------------------
provider "hcloud" {
  # Configuration options
  #token = var.values.hcloud_token
}

#--------------------------------------------------
# Tfstate Remote State Storage
#--------------------------------------------------
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}