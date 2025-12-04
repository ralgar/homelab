data "openstack_networking_network_v2" "prod" {
  name     = "dmz0"
  external = true
}

data "openstack_networking_subnet_v2" "prod" {
  name       = "default"
  network_id = data.openstack_networking_network_v2.prod.id
}

data "openstack_networking_network_v2" "dev" {
  name     = "dmz1"
  external = true
}

data "openstack_networking_subnet_v2" "dev" {
  name       = "default"
  network_id = data.openstack_networking_network_v2.dev.id
}

data "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
}

data "openstack_identity_project_v3" "prod" {
  name = var.deployment
}
