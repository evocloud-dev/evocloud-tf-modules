#--------------------------------------------------
# Supported Cloud Provider
#--------------------------------------------------
provider "google" {
  # Configuration options
  #project = var.gcp_project_id
  #region  = var.gcp_region
}

#--------------------------------------------------
# Tfstate Remote State Storage
#--------------------------------------------------
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "gcs" {}
}