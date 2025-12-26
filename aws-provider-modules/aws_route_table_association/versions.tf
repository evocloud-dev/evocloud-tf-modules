#--------------------------------------------------
# Supported Terraform Version
#--------------------------------------------------
terraform {
  #Terraform required version
  required_version = ">= 1.0.0, < 2.0.0"

  #Providers required version
  required_providers {
    aws = {
      #source  = "terraform.local/evocloud/aws"
      source  = "hashicorp/aws"
      version = "< 7.0.0"
    }
  }
}