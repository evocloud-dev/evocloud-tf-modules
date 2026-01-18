################################################################################
# HCLOUD_VOLUME Resource
#############################################################################
resource "hcloud_volume" "this" {
  for_each = var.values.extra_volumes

  name    = each.value.volume_name
  size    = each.value.volume_size
  format  = each.value.disk_format

  # no space separator in the key or value
  labels = merge(
    {
      "managed-by"  = "EvoCloud"
      "attached-to" = "${each.value.attach_to}"
    },
    {{- if $.Values.extra_volumes.tags }}
    each.tags
    {{- end }}
  )
}

################################################################################
# HCLOUD_VOLUME_ATTACHMENT Resource
#############################################################################

# Fetch the server_id for an existing hcloud_server resource
data "hcloud_server" "this" {
  for_each  = var.values.extra_volumes
  name      = each.value.attach_to
}

resource "hcloud_volume_attachment" "this" {
  for_each  = var.values.extra_volumes

  server_id = data.hcloud_server.this[each.value.attach_to].id
  volume_id = hcloud_volume.this[each.value.attach_to].id
  automount = each.value.automount
}