variable "values" {
  type = object({
    security_groups   = optional(map(object({
      name            = optional(string)

      ingress_rules   = optional(list(object({
        protocol      = string
        port          = string
        source_cidr_blocks  = list(string)
        description         = optional(string)
      })))

    })))
  })
}
