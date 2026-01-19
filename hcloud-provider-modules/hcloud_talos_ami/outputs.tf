#------------------------------------------------------
# Expose TALOS AMI Resource Attributes
#------------------------------------------------------
output "talos_ami_id" {
  value = try(hcloud_snapshot.talos_ami.id, null)
}

output "talos_ami_details" {
  value = try(hcloud_snapshot.talos_ami, null)
}