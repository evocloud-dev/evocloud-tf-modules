variable "values" {
  type = object({
    extra_volumes    = optional(map(object({
      volume_name     = string
      volume_size     = number
      disk_format     = string
      attach_to       = string
      automount       = optional(bool, true)
      tags            = optional(map(string))
    })))
  })

  #Variable validation logic
  validation {
    condition = alltrue([
      for vol in var.values.extra_volumes : contains(["xfs", "ext4"], vol.disk_format)
    ])
    error_message = "disk_format must be set to xfs or ext4 "
  }
}
