data "openstack_networking_network_v2" "dmz0" {
  name     = "dmz0"
  external = true
}

data "openstack_networking_network_v2" "dmz1" {
  name     = "dmz1"
  external = true
}

data "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
}

data "openstack_identity_project_v3" "prod" {
  name = "prod"
}
