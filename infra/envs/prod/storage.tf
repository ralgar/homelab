resource "openstack_blockstorage_volume_v3" "container_data" {
  name        = "container-data"
  description = "Container data volume."
  volume_type = "PREMIUM"
  size        = 15

  enable_online_resize = true
}

resource "openstack_blockstorage_volume_v3" "media" {
  name        = "media"
  description = "Media server storage volume."
  volume_type = "__DEFAULT__"
  size        = 4000

  enable_online_resize = true
}
