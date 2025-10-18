// Create the internal (private) network
resource "openstack_networking_network_v2" "internal" {
  name           = var.network_name
  admin_state_up = "true"

  tags = var.tags
}

resource "openstack_networking_subnet_v2" "default" {
  name       = "default"
  network_id = openstack_networking_network_v2.internal.id
  cidr       = var.default_subnet_cidr
  ip_version = 4

  dns_nameservers = ["1.1.1.1", "1.0.0.1"]

  tags = var.tags
}

// Create the router between the internal and external networks
resource "openstack_networking_router_v2" "internal" {
  name                = var.network_name
  admin_state_up      = true
  external_network_id = var.external_network.id

  tags = var.tags
}

resource "openstack_networking_router_interface_v2" "internal" {
  router_id = openstack_networking_router_v2.internal.id
  subnet_id = openstack_networking_subnet_v2.default.id
}

resource "openstack_networking_router_route_v2" "internal_default" {
  depends_on       = [openstack_networking_router_interface_v2.internal]
  router_id        = openstack_networking_router_v2.internal.id
  destination_cidr = "0.0.0.0/0"
  next_hop         = data.openstack_networking_subnet_v2.external.gateway_ip
}
