resource "openstack_networking_network_v2" "dmz0" {
  count          = var.environment == "prod" ? 1 : 0
  name           = "dmz0"
  admin_state_up = "true"

  external = true
  shared   = true

  segments {
    physical_network = "physnet1"
    network_type     = "vlan"
    segmentation_id  = 10
  }
}

resource "openstack_networking_subnet_v2" "dmz0" {
  count       = var.environment == "prod" ? 1 : 0
  name        = "default"
  network_id  = openstack_networking_network_v2.dmz0[0].id

  cidr            = "10.254.10.0/30"
  gateway_ip      = "10.254.10.1"
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]
  enable_dhcp     = false
}
