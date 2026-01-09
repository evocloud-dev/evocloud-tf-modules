variable "values" {
  type = object({
    bucket_name           = string
    enable_public_access  = optional(bool, false)
  })
}
