module "k8s_network" {
  source = "../../modules/openstack/network"

  network_name        = "k8s_net"
  default_subnet_cidr = "10.0.0.0/24"
  external_network    = data.openstack_networking_network_v2.public
}
