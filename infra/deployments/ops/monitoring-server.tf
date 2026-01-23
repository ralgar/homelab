locals {
  monitoring_server_fqdn = "monitoring.${openstack_dns_zone_v2.ops.name}"
}

# DNS record for monitoring server
resource "openstack_dns_recordset_v2" "monitoring" {
  zone_id     = openstack_dns_zone_v2.ops.id
  description = "Monitoring server (${var.environment})"

  name    = local.monitoring_server_fqdn
  type    = "A"
  records = [module.monitoring_server.ipv4_address]
}

module "monitoring_backups" {
  source      = "../../modules/ignition/backups"
  environment = var.environment
  fqdn        = trimsuffix(local.monitoring_server_fqdn, ".")

  backblaze_account_id  = var.backblaze_account_id
  backblaze_account_key = var.backblaze_account_key
  backblaze_bucket      = var.backblaze_bucket
  restic_password       = var.restic_password
}

module "monitoring_server" {
  source       = "../../modules/openstack/fcos-instance"
  fcos_version = 43

  name = "Monitoring Server"
  flavor_name = "c1.small"
  container_storage_size = 20

  domain  = trimsuffix(local.monitoring_server_fqdn, ".")
  keypair = data.openstack_compute_keypair_v2.admin

  quadlets = {
    "${path.module}/quadlets/uptime-kuma.container" = {}
  }

  // Additional Ignition configs to merge
  ignition_configs = [
    module.monitoring_backups.ignition_config,
  ]

  // Network configuration
  network_id = var.environment == "prod" ? data.openstack_networking_network_v2.prod.id : data.openstack_networking_network_v2.dev.id
  subnet_id = var.environment == "prod" ? data.openstack_networking_subnet_v2.prod.id : data.openstack_networking_subnet_v2.dev.id
  secgroup_ids = [openstack_networking_secgroup_v2.monitoring.id]
}

resource "openstack_networking_secgroup_v2" "monitoring" {
  name        = "Monitoring"
  description = "Controls network traffic for the monitoring server"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = "${openstack_networking_secgroup_v2.monitoring.id}"
  description       = "SSH"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.management_network
}

resource "openstack_networking_secgroup_rule_v2" "uptime_kuma" {
  security_group_id = "${openstack_networking_secgroup_v2.monitoring.id}"
  description       = "HTTP"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3001
  port_range_max    = 3001
  remote_ip_prefix  = var.management_network
}
