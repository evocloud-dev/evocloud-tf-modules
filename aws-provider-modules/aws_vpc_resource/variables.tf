variable "values" {
  type = object({
    cidr_block            = optional(string)
    instance_tenancy      = optional(string)
    enable_dns_support    = optional(bool)
    enable_dns_hostnames  = optional(bool)
    enable_network_address_usage_metrics = optional(bool)
    tags                  = optional(map(string))

    dhcp_options          = optional(object({
      domain_name         = optional(string)
      domain_name_servers = optional(list(string), ["AmazonProvidedDNS"])
      ntp_servers         = optional(list(string))
      tags                = optional(map(string), { Name = "custom-dhcp-options" })
    }))
  })
}