#--------------------------------------------------
# Supported Cloud Provider
#--------------------------------------------------
provider "hcloud" {
  # Configuration options
}

#--------------------------------------------------
# Tfstate Remote State Storage
#--------------------------------------------------
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}