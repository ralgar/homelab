resource "openstack_networking_secgroup_v2" "talos" {
  name = "talos"
}

resource "openstack_networking_secgroup_rule_v2" "allow_all" {
  security_group_id = "${openstack_networking_secgroup_v2.talos.id}"
  description       = "Allow all"
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
}
