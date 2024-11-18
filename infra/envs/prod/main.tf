data "openstack_networking_network_v2" "dmz0" {
  name     = "dmz0"
  external = true
}

data "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
}
