resource "openstack_networking_secgroup_v2" "openstack_test" {
  name        = "openstack-test-pipeline"
  description = "OpenStack deployment testing pipeline"
}

resource "openstack_networking_secgroup_rule_v2" "allow_all_ipv4" {
  security_group_id = "${openstack_networking_secgroup_v2.openstack_test.id}"
  description       = "Allow all IPv4"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
}
