module "fcos" {
  source = "../../modules/openstack/fcos-mediasrv"

  image   = openstack_images_image_v2.coreos_38
  keypair = data.openstack_compute_keypair_v2.admin
  network = data.openstack_networking_network_v2.public

  // Storage volumes
  data_volume  = openstack_blockstorage_volume_v3.container_data
  media_volume = openstack_blockstorage_volume_v3.media

  // Backups configuration
  restic_password = var.restic_password
  gdrive_oauth    = var.gdrive_oauth
}
