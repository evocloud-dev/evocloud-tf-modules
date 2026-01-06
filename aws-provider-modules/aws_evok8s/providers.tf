#--------------------------------------------------
# Supported Cloud Provider
#--------------------------------------------------
provider "aws" {
  # Configuration options
  default_tags {
    tags = {
      Platform  = "EvoCloud-PaaS"
    }
  }

}

provider "talos" {
  # Configuration options
}

#--------------------------------------------------
# Tfstate Remote State Storage
#--------------------------------------------------
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}