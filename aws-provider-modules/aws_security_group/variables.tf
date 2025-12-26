variable "values" {
  type = object({
    VPC_ID                  = optional(string)
    enable_default_egress   = optional(bool)

    security_groups         = optional(map(object({
      name            = optional(string)
      description     = optional(string)

      ingress_rules   = optional(list(object({
        from_port = number
        to_port   = number
        protocol  = string
        cidr_blocks = optional(list(string))
        self        = optional(bool, false)
        description = optional(string)
      })))

      egress_rules   = optional(list(object({
        from_port = number
        to_port   = number
        protocol  = string
        cidr_blocks = optional(list(string))
        description = optional(string)
      })))

    })))
  })
}

# Variables in original terraform main.tf
#variable "VPC_ID" {
#  description = "ID of the VPC"
#  type = string
#  default = "vpc-0bdcab4d22b8c8975"
#}

#variable "security_groups" {
#  description = "Map of security groups parameters and their configurations"
#  type = map(object({
#    name        = string
#    description = string

#    ingress_rules = optional(list(object({
#      from_port = number
#      to_port   = number
#      protocol  = string
#      cidr_blocks = optional(list(string))
#      self        = optional(bool, false)
#      description = optional(string)
#    })), [])

#    egress_rules  = optional(list(object({
#      from_port = number
#      to_port   = number
#      protocol  = string
#      cidr_blocks = optional(list(string))
#      description = optional(string)
#    })), [])
#  }))

#  default = {
#    "infra" = {
#      name = "infra-security-group"
#      description = "Infrastructure Security Group for VPC"
#      ingress_rules = [
#        {
#          from_port   = 22
#          to_port     = 22
#          protocol    = "tcp"
#          description = "SSH Application Access"
#          cidr_blocks = ["0.0.0.0/0"]
#        },
#        {
#          from_port   = 80
#          to_port     = 80
#          protocol    = "tcp"
#          description = "HTTP Application Access"
#          cidr_blocks = ["0.0.0.0/0"]
#        },
#        {
#          from_port   = 443
#          to_port     = 443
#          protocol    = "tcp"
#         description = "HTTPS Application Access"
#          cidr_blocks = ["0.0.0.0/0"]
#        }
#      ]
#    }
#  }
#}

#variable "enable_default_egress" {
#  description = "Boolean flag to set a default allow-all outbound rules if egress_rules is not provided"
#  type = bool
#  default = true
#}