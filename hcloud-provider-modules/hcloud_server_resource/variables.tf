variable "values" {
  type = object({
    hcloud_servers    = optional(map(object({
      VPC_ID          = number
      VPC_CIDR        = optional(string)
      vpc_gateway_ip  = optional(string)
      SECURITY_GROUP_IDS  = optional(list(string))
      name                = string
      compute_flavor      = string
      machine_image       = string
      zone_location       = string
      HOST_SSH_KEY        = string
      private_ip          = optional(string)
      enable_public_ip          = optional(bool, false)
      enable_delete_protection  = optional(bool)
      server_role               = optional(string)
      tags                      = optional(map(string))
    })))
  })

  #Variable validation logic
  validation {
    condition = alltrue([
      for host in var.values.hcloud_servers : contains(["cloudinit-gateway", "cloudinit-nat", "no-cloudinit"], host.server_role)
    ])
    error_message = "server_role must be set to cloudinit-gateway or cloudinit-nat or no-cloudinit."
  }
}
