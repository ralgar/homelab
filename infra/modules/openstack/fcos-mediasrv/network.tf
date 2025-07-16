resource "openstack_networking_port_v2" "fcos" {
  name               = "mediasrv_port"
  network_id         = var.network.id
  admin_state_up     = true
  security_group_ids = [openstack_networking_secgroup_v2.fcos.id]

  fixed_ip {
    subnet_id = var.network.subnets[0]
  }
}
