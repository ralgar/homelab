resource "openstack_networking_secgroup_v2" "media_server" {
  name        = "Media Server"
  description = "Allows SSH, HTTP/S, and MQTT."
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  security_group_id = "${openstack_networking_secgroup_v2.media_server.id}"
  description       = "SSH"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.management_network
}

resource "openstack_networking_secgroup_rule_v2" "http" {
  security_group_id = "${openstack_networking_secgroup_v2.media_server.id}"
  description       = "HTTP"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "https" {
  security_group_id = "${openstack_networking_secgroup_v2.media_server.id}"
  description       = "HTTPS"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "mqtt" {
  security_group_id = "${openstack_networking_secgroup_v2.media_server.id}"
  description       = "MQTT"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1883
  port_range_max    = 1883
  remote_ip_prefix  = "0.0.0.0/0"
}
