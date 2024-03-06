resource "openstack_compute_flavor_v2" "openstack" {
  name      = "openstack"
  ram       = "24578"
  vcpus     = "8"
  disk      = "0"
}

resource "openstack_compute_instance_v2" "openstack" {
  name      = "openstack-test"
  flavor_id = openstack_compute_flavor_v2.openstack.id
  key_pair  = openstack_compute_keypair_v2.ephemeral.name

  // Root Volume from Image
  block_device {
    uuid                  = openstack_images_image_v2.rocky9_cloud.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 40
    boot_index            = 0
    delete_on_termination = true
  }

  // LVM "Premium" Storage Volume
  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = 20
    boot_index            = -1
    delete_on_termination = true
  }

  // LVM "Standard" Storage Volume
  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = 20
    boot_index            = -1
    delete_on_termination = true
  }

  // Object Storage Volume 1
  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = 20
    boot_index            = -1
    delete_on_termination = true
  }

  // Object Storage Volume 2
  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = 20
    boot_index            = -1
    delete_on_termination = true
  }

  // Object Storage Volume 3
  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = 20
    boot_index            = -1
    delete_on_termination = true
  }

  network {
    uuid = data.openstack_networking_network_v2.public.id
  }

  network {
    uuid = data.openstack_networking_network_v2.public.id
  }

  security_groups = [ "default", openstack_networking_secgroup_v2.openstack_test.name ]
}
