#--------------------------------------------------
# Expose HCLOUD_VOLUME Attributes
#--------------------------------------------------

output "volume_details" {
  description = "Output of each volume as an object"
  value       = try (hcloud_volume.this, null)
}