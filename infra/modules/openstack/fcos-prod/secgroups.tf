resource "openstack_networking_secgroup_v2" "prod" {
  name        = "prod-mediasrv"
  description = "Production media server"
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = "${openstack_networking_secgroup_v2.prod.id}"
  description       = "SSH"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  security_group_id = "${openstack_networking_secgroup_v2.prod.id}"
  description       = "HTTPS"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "jellyfin" {
  security_group_id = "${openstack_networking_secgroup_v2.prod.id}"
  description       = "Jellyfin"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8096
  port_range_max    = 8096
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "hass" {
  security_group_id = "${openstack_networking_secgroup_v2.prod.id}"
  description       = "Home Assistant"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8123
  port_range_max    = 8123
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "mqtt" {
  security_group_id = "${openstack_networking_secgroup_v2.prod.id}"
  description       = "MQTT"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1883
  port_range_max    = 1883
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "radarr" {
  security_group_id = "${openstack_networking_secgroup_v2.prod.id}"
  description       = "Radarr"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 7878
  port_range_max    = 7878
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "sonarr" {
  security_group_id = "${openstack_networking_secgroup_v2.prod.id}"
  description       = "Sonarr"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8989
  port_range_max    = 8989
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "prowlarr" {
  security_group_id = "${openstack_networking_secgroup_v2.prod.id}"
  description       = "Prowlarr"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9696
  port_range_max    = 9696
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "nzbget" {
  security_group_id = "${openstack_networking_secgroup_v2.prod.id}"
  description       = "NZBGet"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6789
  port_range_max    = 6789
  remote_ip_prefix  = "0.0.0.0/0"
}
