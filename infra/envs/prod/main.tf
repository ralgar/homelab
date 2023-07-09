data "openstack_networking_network_v2" "public" {
  name     = "public"
  external = true
}

data "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
}

resource "openstack_images_image_v2" "coreos_38" {
  name             = "Fedora CoreOS 38"
  image_source_url = "https://github.com/ralgar/images/releases/download/fedora-coreos/fedora-coreos-38.20230414.3.0-openstack.x86_64.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
  web_download     = true

  properties = {
    os_distro     = "fedora-coreos"
    os_hash_algo  = "sha256"
    os_hash_value = "c092ca53365231608875525cd5ddffd6803c8fa508f923cda8ab719aa02644e5"
  }
}
