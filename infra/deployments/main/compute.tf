module "backups" {
  source      = "../../modules/ignition/backups"
  environment = var.environment

  backblaze_account_id  = var.backblaze_account_id
  backblaze_account_key = var.backblaze_account_key
  backblaze_bucket      = var.backblaze_bucket
  restic_password       = var.restic_password
}

module "mediasrv" {
  source      = "../../modules/ignition/mediasrv"
  environment = var.environment
  domain      = trimsuffix(local.environment_domain, ".")
}

module "fcos" {
  source       = "../../modules/openstack/fcos-mediasrv"
  fcos_version = 41

  domain  = trimsuffix(local.environment_domain, ".")
  keypair = data.openstack_compute_keypair_v2.admin

  ignition_configs = [
    module.backups.ignition_config,
    module.mediasrv.ignition_config
  ]

  // Additional data storage volumes to attach
  volumes = [
    openstack_blockstorage_volume_v3.container_data,
    openstack_blockstorage_volume_v3.media
  ]

  // Network configuration
  network = var.environment == "prod" ? data.openstack_networking_network_v2.prod : data.openstack_networking_network_v2.dev
}
