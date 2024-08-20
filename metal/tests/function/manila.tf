resource "openstack_sharedfilesystem_sharenetwork_v2" "sharenetwork_1" {
  name              = "test_sharenetwork"
  description       = "Test share network with security services"
  neutron_net_id    = openstack_networking_network_v2.test_network_1.id
  neutron_subnet_id = openstack_networking_subnet_v2.test_subnet_1.id
}

resource "openstack_sharedfilesystem_share_v2" "test_share_nfs" {
  name             = "nfs_share"
  description      = "Test NFS share"
  share_proto      = "NFS"
  share_type       = "default_share_type"
  size             = 1
  share_network_id = openstack_sharedfilesystem_sharenetwork_v2.sharenetwork_1.id
}

resource "openstack_sharedfilesystem_share_access_v2" "share_access_1" {
  share_id     = openstack_sharedfilesystem_share_v2.test_share_nfs.id
  access_type  = "ip"
  access_to    = openstack_compute_instance_v2.cirros.access_ip_v4
  access_level = "rw"
}
