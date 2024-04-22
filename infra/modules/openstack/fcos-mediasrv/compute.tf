data "openstack_images_image_v2" "fcos" {
  visibility  = "public"
  most_recent = true

  properties = {
    os_distro  = "fedora-coreos"
    os_version = "${var.fcos_version}"
  }
}

resource "openstack_compute_instance_v2" "fcos" {
  name                = "FCOS Media Server"
  flavor_name         = "m1.large"
  key_pair            = var.keypair.name
  user_data           = data.ignition_config.final.rendered
  stop_before_destroy = true

  block_device {
    uuid                  = data.openstack_images_image_v2.fcos.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "PREMIUM"
    volume_size           = 80
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = var.data_volume.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = false
    multiattach           = true
  }

  block_device {
    uuid                  = var.media_volume.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = false
    multiattach           = true
  }

  network {
    uuid = var.network.id
  }

  security_groups = [ "default", openstack_networking_secgroup_v2.fcos.name ]
}
