module "fcos" {
  source       = "../../modules/openstack/fcos-mediasrv"
  fcos_version = 41

  keypair = data.openstack_compute_keypair_v2.admin

  // Network configuration
  network = var.environment == "prod" ? data.openstack_networking_network_v2.prod : data.openstack_networking_network_v2.dev

  // Storage volumes
  data_volume  = openstack_blockstorage_volume_v3.container_data
  media_volume = openstack_blockstorage_volume_v3.media

  // Backups configuration
  restic_password = var.restic_password
  gdrive_oauth    = var.gdrive_oauth

  // Services configuration
  environment = var.environment
  domain      = trimsuffix(local.environment_domain, ".")
}
