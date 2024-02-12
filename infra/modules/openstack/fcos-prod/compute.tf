resource "openstack_compute_instance_v2" "fcos" {
  name                = "Production FCOS"
  image_id            = var.image.id
  flavor_name         = "m1.large"
  key_pair            = var.keypair.name
  user_data           = data.ignition_config.final.rendered
  stop_before_destroy = true

  block_device {
    uuid                  = var.image.id
    source_type           = "image"
    destination_type      = "local"
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

  security_groups = [ "default", openstack_networking_secgroup_v2.prod.name ]
}
