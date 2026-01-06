variable "values" {
  type = object({
    vpc_name          = optional(string)
    vpc_routing_mode  = optional(string)
    custom_mtu        = optional(number)
  })

  #Variable validation
  validation {
    condition = contains(["GLOBAL", "REGIONAL"], var.values.vpc_routing_mode)
    error_message = "routing_mode must be set to REGIONAL or GLOBAL."
  }

  validation {
    condition = (
      var.values.custom_mtu == null ? true : (var.values.custom_mtu >= 1300 && var.values.custom_mtu <= 8896)
    )
    error_message = "MTU value must be a number and the minimum value is 1300 and the maximum value is 8896 (jumbo frames)."
  }
}

#variable "vpc_name" {
#  description = "GCP Compute Virtual Network Name"
#  type = string
#  default = "evocloud-vpc"
#}

#variable "vpc_routing_mode" {
#  description = "GCP Network-wide routing mode"
#  type = string
#  default = "REGIONAL" # Can be set to REGIONAL or GLOBAL
#}