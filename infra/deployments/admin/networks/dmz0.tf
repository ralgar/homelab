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

  cidr            = "10.254.10.0/24"
  gateway_ip      = "10.254.10.1"
  dns_nameservers = ["10.254.10.1", "1.1.1.1", "8.8.8.8"]
  enable_dhcp     = true

  allocation_pool {
    start = "10.254.10.10"
    end   = "10.254.10.254"
  }
}
