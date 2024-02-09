resource "openstack_blockstorage_volume_v3" "media" {
  name        = "media"
  description = "Media server storage volume (dev)."
  volume_type = "__DEFAULT__"
  size        = 256

  enable_online_resize = true
}
