variable "values" {
  type = object({
    VPC_ID                = number
    destination_net_cidr  = string
    nat_host_ip       = string
  })
}
