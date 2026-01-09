variable "ami_owner_id" {
  description = "Base AMI Owner ID"
  type = string
  default = "540036508848"
}

variable "ami_name_param" {
  description = "Base AMI Name Parameter for filtering"
  type = string
  default = "talos-v1.12.0-us-east-2-amd64"
}

variable "ami_image_version" {
  description = "Base AMI Image Version"
  type = string
  default = "v1.12.0"
}

variable "ami_image_arch" {
  description = "Base AMI Image Version"
  type = string
  default = "x86_64"
}

variable "ami_image_region" {
  description = "Base AMI Image Region"
  type = string
  default = "us-east-2"
}

#tags must be a variable