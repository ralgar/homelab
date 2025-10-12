resource "openstack_blockstorage_volume_v3" "container_storage" {
  name        = "${var.name} Container Storage"
  description = "Semi-persistent storage for Podman images and volumes"
  volume_type = "PREMIUM"
  size        = var.container_storage_size

  enable_online_resize = true
}
