data "openstack_networking_subnet_v2" "external" {
  network_id = var.external_network.id
}
