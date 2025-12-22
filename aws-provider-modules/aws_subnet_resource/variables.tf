variable "values" {
  type = object({
    VPC_ID                = optional(string)
    VPC_CIDR_BLOCK        = optional(string)
    desired_subnet_names  = optional(list(string))
    subnet_number         = optional(map(number))
    subnet_newbits        = optional(number)
    #tags                  = optional(map(string))
  })
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

#variable "desired_subnet_names" {
#  description = "List of subnets to create"
#  type = list(string)
#  default = ["admin-subnet", "backend-subnet", "dmz-subnet"]
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