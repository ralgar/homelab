data "openstack_networking_network_v2" "dmz2" {
  name       = "dmz2"
  external   = true
  depends_on = [module.networks]
}
