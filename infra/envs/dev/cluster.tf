module "gcp_bucket" {
  source = "../../modules/gcp/bucket"

  name_prefix = "homelab-backups"
}

module "k8s_network" {
  source = "../../modules/openstack/network"

  network_name        = "k8s_net"
  default_subnet_cidr = "10.0.0.0/24"
  external_network    = data.openstack_networking_network_v2.public
}

module "k8s_cluster" {
  source = "../../modules/openstack/k8s-cluster"

  image            = openstack_images_image_v2.coreos_37
  keypair          = data.openstack_compute_keypair_v2.admin

  // Node Settings
  ha_control_plane  = false
  base_worker_count = 1

  // Networking
  internal_network = module.k8s_network.network
  internal_subnet  = module.k8s_network.default_subnet
  external_network = data.openstack_networking_network_v2.public

  bootstrap = {
    enabled    = true
    repository = var.gitops_repo
    ref_name   = var.gitops_ref_name
    path       = var.gitops_path

    configs = {
      DOMAIN                  = trimsuffix(openstack_dns_zone_v2.environment.name, ".")
      MEDIA_VOLUME_ID         = openstack_blockstorage_volume_v3.media.id
      MEDIA_VOLUME_SIZE       = "${openstack_blockstorage_volume_v3.media.size}Gi"
    }

    secrets = {
      GCP_BACKUP_BUCKET_NAME  = module.gcp_bucket.name
      GCP_BACKUP_BUCKET_CREDS = module.gcp_bucket.service_account_key  # base64
      PGSQL_BACKUP_PASSWORD   = var.pgsql_backup_password
      DESIGNATE_AUTH_ID       = openstack_identity_application_credential_v3.designate.id
      DESIGNATE_AUTH_SECRET   = openstack_identity_application_credential_v3.designate.secret
    }
  }
}
