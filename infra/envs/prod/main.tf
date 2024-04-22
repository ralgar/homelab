data "openstack_networking_network_v2" "public" {
  name     = "public"
  external = true
}

data "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
}
