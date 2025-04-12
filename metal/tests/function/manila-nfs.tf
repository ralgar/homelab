resource "openstack_sharedfilesystem_share_v2" "test_share_nfs" {
  name             = "nfs_share"
  description      = "Test NFS share"
  share_proto      = "NFS"
  share_type       = "default_share_type"
  size             = 1
}

resource "openstack_sharedfilesystem_share_access_v2" "share_access_1" {
  share_id     = openstack_sharedfilesystem_share_v2.test_share_nfs.id
  access_type  = "ip"
  access_to    = openstack_compute_instance_v2.cirros.access_ip_v4
  access_level = "rw"
}
