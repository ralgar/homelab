data "openstack_compute_keypair_v2" "admin" {
  name       = "admin"
}

data "openstack_networking_network_v2" "public" {
  name     = "public"
  external = true
}

resource "tls_private_key" "ephemeral" {
  algorithm = "ED25519"
}

resource "openstack_compute_keypair_v2" "ephemeral" {
  name       = "openstack-test-pipeline-ephemeral"
  public_key = tls_private_key.ephemeral.public_key_openssh
}

resource "openstack_images_image_v2" "rocky9_cloud" {
  name             = "Rocky 9 Cloud Image"
  image_source_url = "https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
  web_download     = true
}
