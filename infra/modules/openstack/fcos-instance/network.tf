resource "openstack_networking_port_v2" "fcos" {
  name               = "${var.name} Port"
  network_id         = var.network.id
  admin_state_up     = true
  security_group_ids = var.secgroup_ids

  fixed_ip {
    subnet_id = var.network.subnets[0]
  }
}
