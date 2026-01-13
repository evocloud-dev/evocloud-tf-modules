variable "values" {
  type = object({
    ssh_key_name   = string
    tags           = optional(map(string))
  })
}