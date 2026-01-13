#------------------------------------------------------
# Expose HCLOUD_SSK_KEY and TLS_PRIVATE_KEY Attributes
#------------------------------------------------------
output "ssh_private_key" {
  value = try(tls_private_key.this.private_key_openssh, null)
  sensitive = true
}

output "ssh_public_key" {
  value = try(tls_private_key.this.public_key_openssh, null)
  sensitive = true
}

output "hcloud_ssh_key_name" {
  value = try(hcloud_ssh_key.this.name, null)
}

output "hcloud_ssh_key_id" {
  value = try(hcloud_ssh_key.this.id, null)
}