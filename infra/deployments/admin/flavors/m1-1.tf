resource "openstack_compute_flavor_v2" "m1_tiny_1" {
  name      = var.environment == "prod" ? "m1.tiny" : "m1.tiny (${var.environment})"
  vcpus     = "1"
  ram       = "512"
  disk      = "0"
  is_public = var.environment == "prod" ? true : false

  extra_specs = {
    "hw:disk_bus"   = "scsi"
    "hw:scsi_model" = "virtio-scsi"
  }
}

resource "openstack_compute_flavor_v2" "m1_small_1" {
  name      = var.environment == "prod" ? "m1.small" : "m1.small (${var.environment})"
  vcpus     = "1"
  ram       = "2048"
  disk      = "0"
  is_public = var.environment == "prod" ? true : false

  extra_specs = {
    "hw:disk_bus"   = "scsi"
    "hw:scsi_model" = "virtio-scsi"
  }
}

resource "openstack_compute_flavor_v2" "m1_medium_1" {
  name      = var.environment == "prod" ? "m1.medium" : "m1.medium (${var.environment})"
  vcpus     = "2"
  ram       = "4096"
  disk      = "0"
  is_public = var.environment == "prod" ? true : false

  extra_specs = {
    "hw:disk_bus"   = "scsi"
    "hw:scsi_model" = "virtio-scsi"
  }
}

resource "openstack_compute_flavor_v2" "m1_large_1" {
  name      = var.environment == "prod" ? "m1.large" : "m1.large (${var.environment})"
  vcpus     = "4"
  ram       = "8192"
  disk      = "0"
  is_public = var.environment == "prod" ? true : false

  extra_specs = {
    "hw:disk_bus"   = "scsi"
    "hw:scsi_model" = "virtio-scsi"
  }
}

resource "openstack_compute_flavor_v2" "m1_xlarge_1" {
  name      = var.environment == "prod" ? "m1.xlarge" : "m1.xlarge (${var.environment})"
  vcpus     = "8"
  ram       = "16384"
  disk      = "0"
  is_public = var.environment == "prod" ? true : false

  extra_specs = {
    "hw:disk_bus"   = "scsi"
    "hw:scsi_model" = "virtio-scsi"
  }
}
