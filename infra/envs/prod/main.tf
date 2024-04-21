data "openstack_networking_network_v2" "public" {
  name     = "public"
  external = true
}

data "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
}

resource "openstack_images_image_v2" "coreos_38" {
  name             = "Fedora CoreOS 38"
  image_source_url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/38.20230806.3.0/x86_64/fedora-coreos-38.20230806.3.0-openstack.x86_64.qcow2.xz"
  container_format = "bare"
  disk_format      = "qcow2"
  decompress       = true

  properties = {
    os_distro     = "fedora-coreos"
    os_hash_algo  = "sha256"
    os_hash_value = "1e7ca33cc0afda45b51587709575244daac050856d820e527e481f46689d5b5f"
  }
}
