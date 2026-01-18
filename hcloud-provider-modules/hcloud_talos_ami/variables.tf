variable "values" {
  type = object({
    talos_version         = string
    talos_schematic_id    = string
    compute_flavor        = optional(string, "cx23")
    machine_image         = optional(string, "debian-12")
    zone_location         = optional(string, "hel1")

  })
}