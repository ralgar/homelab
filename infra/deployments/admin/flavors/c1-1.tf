resource "openstack_compute_flavor_v2" "c1_small_1" {
  name      = var.environment == "prod" ? "c1.small" : "c1.small (${var.environment})"
  vcpus     = "2"
  ram       = "2048"
  disk      = "0"
  is_public = var.environment == "prod" ? true : false

  extra_specs = {
    "hw:disk_bus"   = "scsi"
    "hw:scsi_model" = "virtio-scsi"
  }
}

resource "openstack_compute_flavor_v2" "c1_medium_1" {
  name      = var.environment == "prod" ? "c1.medium" : "c1.medium (${var.environment})"
  vcpus     = "4"
  ram       = "4096"
  disk      = "0"
  is_public = var.environment == "prod" ? true : false

  extra_specs = {
    "hw:disk_bus"   = "scsi"
    "hw:scsi_model" = "virtio-scsi"
  }
}

resource "openstack_compute_flavor_v2" "c1_large_1" {
  name      = var.environment == "prod" ? "c1.large" : "c1.large (${var.environment})"
  vcpus     = "8"
  ram       = "8192"
  disk      = "0"
  is_public = var.environment == "prod" ? true : false

  extra_specs = {
    "hw:disk_bus"   = "scsi"
    "hw:scsi_model" = "virtio-scsi"
  }
}

resource "openstack_compute_flavor_v2" "c1_xlarge_1" {
  name      = var.environment == "prod" ? "c1.xlarge" : "c1.xlarge (${var.environment})"
  vcpus     = "16"
  ram       = "16384"
  disk      = "0"
  is_public = var.environment == "prod" ? true : false

  extra_specs = {
    "hw:disk_bus"   = "scsi"
    "hw:scsi_model" = "virtio-scsi"
  }
}
