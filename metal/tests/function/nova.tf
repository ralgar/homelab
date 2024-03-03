resource "openstack_compute_instance_v2" "cirros" {
  name        = "test-cirros"
  flavor_name = "m1.tiny"

  // Root Volume from Image
  block_device {
    uuid                  = openstack_images_image_v2.cirros.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 8
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = data.openstack_networking_network_v2.public.id
  }

  security_groups = ["default"]
}
