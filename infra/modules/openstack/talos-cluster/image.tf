data "openstack_images_image_v2" "talos" {
  visibility  = "public"
  most_recent = true

  properties = {
    os_distro  = "talos"
    os_version = var.talos_version
  }
}
