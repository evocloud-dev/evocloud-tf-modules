variable "values" {
  type = object({
    cidr_block            = optional(string)
    vpc_name              = optional(string)
    labels                = optional(map(string))
  })
}