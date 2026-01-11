variable "values" {
  type = object({
    VPC_ID                = number
    VPC_CIDR_BLOCK        = optional(string)

    subnets_configs       = optional(list(object({
      subnet_name     = string
      network_tier    = string
      network_zone    = string
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
      for subnet in var.values.subnets_configs : contains(["cloud", "server", "vswitch"], subnet.network_tier)
    ])
    error_message = "Subnets must have type set to cloud or server or vswitch."
  }

  validation {
    condition = length(distinct([for subnet in var.values.subnets_configs : subnet.subnet_name])) == length(var.values.subnets_configs)
    error_message = "Subnets must have a unique subnet_name."
  }
}
