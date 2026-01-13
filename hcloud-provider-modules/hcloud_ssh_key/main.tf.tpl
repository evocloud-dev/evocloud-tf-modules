#--------------------------------------------------
# Generate SSH Key Pair
#--------------------------------------------------
resource "tls_private_key" "this" {
  algorithm = "ED25519" #Recommended - more secure and faster
}

#############################################################################
# HCLOUD_SSH_KEY Resource
#############################################################################
resource "hcloud_ssh_key" "this" {
  name       = var.values.ssh_key_name
  public_key = tls_private_key.this.public_key_openssh

  # no space separator in the key or value
  labels = merge(
    {
      "managed-by"  = "EvoCloud"
    },
    {{- if $.Values.tags }}
    var.values.tags
    {{- end }}
  )
}