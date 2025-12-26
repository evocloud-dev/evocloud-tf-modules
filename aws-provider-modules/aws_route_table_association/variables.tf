
variable "values" {
  type = object({
    PUBLIC_ROUTE_TABLE_ID   = optional(string)
    PRIVATE_ROUTE_TABLE_ID  = optional(string)
    PUBLIC_SUBNET_IDS       = optional(map(string))
    PRIVATE_SUBNET_IDS      = optional(map(string))
  })
}

#variable "PUBLIC_SUBNET_IDS" {
#  description = "Subnet IDs meant to be on the Public Network"
#  type = map(string)
#  default = {
#    "dmz-subnet-us-east-2a": "subnet-075be013287287d6c",
#    "dmz-subnet-us-east-2b": "subnet-0493a2cfbc15cbded",
#    "dmz-subnet-us-east-2c": "subnet-067f603e67a1ad757"
#  }
#}

#variable "PRIVATE_SUBNET_IDS" {
#  description = "Subnet IDs meant to be on the Private Network"
#  type = map(string)
#  default = {
#    "admin-subnet-us-east-2a": "subnet-026ae7ed6dd4c4115",
#    "admin-subnet-us-east-2b": "subnet-0ad548cac4127958a",
#    "admin-subnet-us-east-2c": "subnet-01b035f5ac2fc0866",
#    "backend-subnet-us-east-2a": "subnet-01d4633b01d333d93",
#    "backend-subnet-us-east-2b": "subnet-01bad7b551d0ce84d",
#    "backend-subnet-us-east-2c": "subnet-08bf7ab7db1ab1be9"
#  }
#}
