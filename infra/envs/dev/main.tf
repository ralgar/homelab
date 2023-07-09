data "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
}

data "openstack_networking_network_v2" "public" {
  name     = "public"
  external = true
}

resource "openstack_images_image_v2" "coreos_37" {
  name             = "Fedora CoreOS 37"
  image_source_url = "https://github.com/ralgar/images/releases/download/fedora-coreos/fedora-coreos-37.20230218.3.0-openstack.x86_64.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
  web_download     = true

  properties = {
    os_distro = "fedora-coreos"
  }
}
