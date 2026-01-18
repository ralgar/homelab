module "monitoring_server" {
  source       = "../../modules/openstack/fcos-instance"
  fcos_version = 43

  name = "Monitoring Server"
  flavor_name = "c1.small"
  container_storage_size = 20

  domain  = "monitoring.internal"
  keypair = data.openstack_compute_keypair_v2.admin

  quadlets = {
    "${path.module}/quadlets/uptime-kuma.container" = {}
  }

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
