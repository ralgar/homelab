resource "openstack_networking_network_v2" "test_network_1" {
  name           = "test_network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "test_subnet_1" {
  name       = "test_subnet_1"
  cidr       = "10.254.254.0/24"
  ip_version = 4
  network_id = openstack_networking_network_v2.test_network_1.id
}

// Create the router between the internal and external networks
data "openstack_networking_network_v2" "external" {
  name = "public"
}

data "openstack_networking_subnet_v2" "external" {
  name = "default"
}

resource "openstack_networking_router_v2" "internal" {
  name                = "test_router_1"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external.id
}

resource "openstack_networking_router_interface_v2" "internal" {
  router_id = openstack_networking_router_v2.internal.id
  subnet_id = openstack_networking_subnet_v2.test_subnet_1.id
}

resource "openstack_networking_router_route_v2" "internal_default" {
  depends_on       = [openstack_networking_router_interface_v2.internal]
  router_id        = openstack_networking_router_v2.internal.id
  destination_cidr = "0.0.0.0/0"
  next_hop         = data.openstack_networking_subnet_v2.external.gateway_ip
}
