resource "openstack_compute_flavor_v2" "openstack" {
  name      = "openstack"
  ram       = "16386"
  vcpus     = "8"
  disk      = "60"
}

resource "openstack_compute_instance_v2" "openstack" {
  name      = "openstack-test"
  image_id  = openstack_images_image_v2.rocky9_cloud.id
  flavor_id = openstack_compute_flavor_v2.openstack.id
  key_pair  = data.openstack_compute_keypair_v2.admin.name

  block_device {
    uuid                  = openstack_images_image_v2.rocky9_cloud.id
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = 60
    boot_index            = 1
    delete_on_termination = true
  }

  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = 60
    boot_index            = 2
    delete_on_termination = true
  }

  # Private/Access Network
  network {
    uuid = data.openstack_networking_network_v2.public.id
    access_network = true
  }

  # Public Network (no address)
  network {
    uuid = data.openstack_networking_network_v2.public.id
    fixed_ip_v4 = null
  }

  security_groups = [ "default", openstack_networking_secgroup_v2.openstack_test.name ]
}
