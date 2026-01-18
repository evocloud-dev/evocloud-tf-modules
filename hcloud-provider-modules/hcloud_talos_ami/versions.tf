#--------------------------------------------------
# Supported Terraform Version
#--------------------------------------------------
terraform {
  #Terraform required version
  required_version = ">= 1.0.0, < 2.0.0"

  #Providers required version
  required_providers {
    hcloud = {
      #source  = "terraform.local/evocloud/hcloud"
      source  = "hetznercloud/hcloud"
      version = "< 2.0.0"
    }

    #TLS Key Pair Provider
    tls = {
      source = "hashicorp/tls"
      version = "< 5.0.0"
    }

    #Timer
    time = {
      source = "hashicorp/time"
      version = "0.13.1"
    }
  }
}