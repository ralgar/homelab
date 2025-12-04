module "backups" {
  source      = "../../modules/ignition/backups"
  environment = var.environment
  fqdn        = trimsuffix(local.environment_domain, ".")

  backblaze_account_id  = var.backblaze_account_id
  backblaze_account_key = var.backblaze_account_key
  backblaze_bucket      = var.backblaze_bucket
  healthcheck_url       = var.healthcheck_url
  restic_password       = var.restic_password
}

module "media_server" {
  source       = "../../modules/openstack/fcos-instance"
  fcos_version = 41

  name = "Media Server"
  flavor_name = "m1.large"
  container_storage_size = 20

  domain  = trimsuffix(local.environment_domain, ".")
  keypair = data.openstack_compute_keypair_v2.admin

  quadlets = {
    "${path.module}/quadlets/hass.container" = {}
    "${path.module}/quadlets/jellyfin.container" = {}
    "${path.module}/quadlets/jellyseerr.container" = {}
    "${path.module}/quadlets/mosquitto.container" = {}
    "${path.module}/quadlets/prowlarr.container" = {}
    "${path.module}/quadlets/proxy.network" = {}
    "${path.module}/quadlets/radarr.container" = {}
    "${path.module}/quadlets/sabnzbd.container" = {}
    "${path.module}/quadlets/sonarr.container" = {}
    "${path.module}/quadlets/swag.container" = {
      domain = trimsuffix(local.environment_domain, ".")
      staging = var.environment == "staging" ? "true" : "false"
    }
  }

  // Additional Ignition configs to merge
  ignition_configs = [
    module.backups.ignition_config,
    base64encode(data.ignition_config.additional_storage.rendered),
  ]

  // Additional storage volumes to attach
  volumes = [
    openstack_blockstorage_volume_v3.media
  ]

  // Network configuration
  network_id = var.environment == "prod" ? data.openstack_networking_network_v2.prod.id : data.openstack_networking_network_v2.dev.id
  subnet_id = var.environment == "prod" ? data.openstack_networking_subnet_v2.prod.id : data.openstack_networking_subnet_v2.dev.id
  secgroup_ids = [openstack_networking_secgroup_v2.media_server.id]
}
