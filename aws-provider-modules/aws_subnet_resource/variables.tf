variable "values" {
  type = object({
    VPC_ID                = optional(string)
    VPC_CIDR_BLOCK        = optional(string)

    subnets_configs       = optional(list(object({
      subnet_name     = string
      network_tier    = string
      subnet_number   = number
      subnet_newbits  = number
    })))

  })

  #Variable validation
  validation {
    condition = length(var.values.subnets_configs) >= 1
    error_message = "At least one subnet configuration must be defined."
  }

  validation {
    condition = alltrue([
      for subnet in var.values.subnets_configs : contains(["public", "private"], subnet.network_tier)
    ])
    error_message = "Subnets must have network_tier set to public or private."
  }

  validation {
    condition = length(distinct([for subnet in var.values.subnets_configs : subnet.subnet_name])) == length(var.values.subnets_configs)
    error_message = "Subnets must have a unique subnet_name."
  }
}

# Variables in original terraform main.tf
#variable "VPC_ID" {
#  description = "ID of the VPC"
#  type = string
#  default = "vpc-0bdcab4d22b8c8975"
#}

#variable "VPC_CIDR_BLOCK" {
#  description = "VPC CIDR Block (e.g: 10.10.0.0/16)"
#  type = string
#  default = "10.10.0.0/16"
#}

#variable "subnet_number" {
#  description = "Each subnet must define a number that is used to segment the network CIDR"
#  type = map(number)
#  default = { admin-subnet = 10, backend-subnet = 20, dmz-subnet = 30} #e.g: { admin-subnet = 10, backend-subnet = 20, dmz-subnet = 30}
#}

#variable "subnet_newbits" {
#  description = "Number of additional bits to add to the VPC CIDR for subnet CIDR (i.e: if vpc cidr is /16 adding 8 bits makes a subnet cidr of /24)"
#  type = number
#  default = 8
#}