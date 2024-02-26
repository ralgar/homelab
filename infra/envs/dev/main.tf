data "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
}

data "openstack_networking_network_v2" "public" {
  name     = "public"
  external = true
}

resource "openstack_images_image_v2" "coreos_38" {
  name             = "Fedora CoreOS 38"
  image_source_url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/38.20230806.3.0/x86_64/fedora-coreos-38.20230806.3.0-openstack.x86_64.qcow2.xz"
  container_format = "bare"
  disk_format      = "qcow2"
  decompress       = true

  properties = {
    os_distro = "fedora-coreos"
  }
}
