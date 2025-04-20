resource "openstack_networking_network_v2" "dmz2" {
  count          = var.environment == "prod" ? 1 : 0
  name           = "dmz2"
  admin_state_up = "true"

  external = true
  shared   = true

  segments {
    physical_network = "physnet1"
    network_type     = "vlan"
    segmentation_id  = 12
  }
}

resource "openstack_networking_subnet_v2" "dmz2" {
  count       = var.environment == "prod" ? 1 : 0
  name        = "default"
  network_id  = openstack_networking_network_v2.dmz2[0].id

  cidr            = "10.254.12.0/24"
  gateway_ip      = "10.254.12.1"
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]
  enable_dhcp     = true

  allocation_pool {
    start = "10.254.12.10"
    end   = "10.254.12.254"
  }
}
