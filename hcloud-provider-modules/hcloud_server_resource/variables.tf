variable "values" {
  type = object({
    hcloud_servers    = optional(map(object({
      VPC_ID          = number
      SECURITY_GROUP_IDS  = optional(list(string))
      name                = string
      compute_flavor      = string
      machine_image       = string
      zone_location       = string
      host_ssh_key        = string
      private_ip          = optional(string)
      enable_public_ip          = optional(bool, false)
      enable_delete_protection  = optional(bool)
      enable_gateway_config     = optional(bool)
      tags                      = optional(map(string))
    })))
  })
}
