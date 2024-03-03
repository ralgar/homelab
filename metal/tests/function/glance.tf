resource "openstack_images_image_v2" "cirros" {
  name             = "CirrOS"
  image_source_url = "http://download.cirros-cloud.net/0.5.1/cirros-0.5.1-x86_64-disk.img"
  container_format = "bare"
  disk_format      = "qcow2"
}
