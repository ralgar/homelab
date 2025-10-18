resource "openstack_compute_instance_v2" "worker" {
  count               = var.worker_count
  name                = "${var.cluster_name}-worker-${count.index}"
  flavor_name         = var.worker_flavor
  stop_before_destroy = true

  block_device {
    uuid                  = data.openstack_images_image_v2.talos.id
    source_type           = "image"
    destination_type      = "volume"
    volume_type           = "PREMIUM"
    volume_size           = 40
    boot_index            = 0
    delete_on_termination = true
  }

  // Attach additional block devices to workers
  dynamic "block_device" {
    for_each = toset(range(var.extra_volume_count))
    content {
      source_type           = "blank"
      destination_type      = "volume"
      volume_type           = "__DEFAULT__"
      volume_size           = var.extra_volume_size
      boot_index            = -1
      delete_on_termination = true
    }
  }

  network {
    port = openstack_networking_port_v2.worker[count.index].id
  }
}

resource "openstack_networking_port_v2" "worker" {
  count              = var.worker_count
  name               = "${var.cluster_name}-worker-${count.index}"
  network_id         = var.internal_network.id
  admin_state_up     = true
  security_group_ids = [openstack_networking_secgroup_v2.talos.id]

  fixed_ip {
    subnet_id = var.internal_subnet.id
  }
}

// Optional floating IP for workers
resource "openstack_networking_floatingip_v2" "worker" {
  count     = var.enable_floating_ip ? var.worker_count : 0
  pool      = "dmz3"
  port_id   = openstack_networking_port_v2.worker[count.index].id
}
