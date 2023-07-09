output "network" {
  value = openstack_networking_network_v2.internal
}

output "default_subnet" {
  value = openstack_networking_subnet_v2.default
}
