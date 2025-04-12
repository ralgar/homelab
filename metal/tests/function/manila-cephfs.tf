resource "openstack_sharedfilesystem_share_v2" "test_share_cephfs" {
  name             = "cephfs_share"
  description      = "Test CephFS share"
  share_proto      = "CEPHFS"
  share_type       = "default_share_type"
  size             = 1
}
