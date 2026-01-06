#--------------------------------------------------
# Expose GOOGLE_COMPUTE_NETWORK Attributes
#--------------------------------------------------
output "vpc_id" {
  value = google_compute_network.this.id
}

output "vpc_name" {
  value = google_compute_network.this.name
}