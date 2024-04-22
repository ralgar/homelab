module "fcos" {
  source       = "../../modules/openstack/fcos-mediasrv"
  fcos_version = 39

  keypair = data.openstack_compute_keypair_v2.admin

  // Network configuration
  network = data.openstack_networking_network_v2.public
  dns_zone = openstack_dns_zone_v2.environment

  // Storage volumes
  data_volume  = openstack_blockstorage_volume_v3.container_data
  media_volume = openstack_blockstorage_volume_v3.media

  // Backups configuration
  restic_password = var.restic_password
  gdrive_oauth    = var.gdrive_oauth

  // Services configuration
  environment = var.environment
  domain      = trimsuffix(openstack_dns_zone_v2.environment.name, ".")
}
