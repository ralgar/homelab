data "openstack_images_image_v2" "fcos" {
  visibility  = "public"
  most_recent = true

  properties = {
    os_distro  = "fedora-coreos"
    os_version = "${var.fcos_version}"
  }
}

resource "openstack_compute_instance_v2" "fcos" {
  name                = var.name
  flavor_name         = var.flavor_name
  key_pair            = var.keypair.name
  user_data           = data.ignition_config.final.rendered
  stop_before_destroy = true

  block_device {
    uuid                  = data.openstack_images_image_v2.fcos.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "PREMIUM"
    volume_size           = 10
    boot_index            = 0
    delete_on_termination = true
  }

  // Storage for Podman images and volumes (`/var/lib/containers/storage`)
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.container_storage.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = false
  }

  // Attach additional block devices
  dynamic "block_device" {
    for_each = var.volumes
    content {
      uuid                  = block_device.value.id
      source_type           = "volume"
      destination_type      = "volume"
      boot_index            = -1
      delete_on_termination = false
    }
  }

  network {
    port = openstack_networking_port_v2.fcos.id
  }
}
