variable "values" {
  type = object({
    cidr_block            = optional(string)
    instance_tenancy      = optional(string)
    enable_dns_support    = optional(bool)
    enable_dns_hostnames  = optional(bool)
    enable_network_address_usage_metrics = optional(bool)
    tags = optional(map(string))
  })
}