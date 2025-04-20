data "openstack_images_image_v2" "fcos_41_latest" {
  most_recent = true

  properties = {
    os_distro  = "fedora-coreos"
    os_version = "41"
  }
}
