variable "talos_ami_id" {
  description = "Talos AMI ID"
  type = string
  default = "ami-065b35627f6d37d67"
}

variable "vm_flavor" {
  description = "Instance resource sizing/flavor"
  type = string
  default = "t2.2xlarge"
}

variable "subnet_id" {
  description = "Subnet ID where the AWS Instance will be deployed to"
  type = string
  default = "subnet-0c5d66b5b3966bab9"
}

variable "vpc_security_group_id" {
  description = "VPC Security Group ID to attach to the AWS Instance"
  type = list(string)
  default = ["sg-006acee81dcd41425"]
}

variable "use_spot" {
  description = "Boolean to enable Spot Instances"
  type = bool
  default = true
}

#associate_public_ip_address when set to true

#tags must be a variable