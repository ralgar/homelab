resource "openstack_images_image_v2" "fcos_41_2025_03_15" {
  name             = "Fedora CoreOS 41 (2025.03.15)"
  image_source_url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/41.20250331.3.0/x86_64/fedora-coreos-41.20250331.3.0-openstack.x86_64.qcow2.xz"

  container_format = "bare"
  disk_format      = "qcow2"
  decompress       = true
  min_disk_gb      = 10
  min_ram_mb       = 1536
  visibility       = var.environment == "prod" ? "public" : "private"

  properties = {
    architecture  = "x86_64"
    os_type       = "linux"
    os_distro     = "fedora-coreos"
    os_version    = "41"
    os_admin_user = "core"

    cinder_img_volume_type = "PREMIUM"
  }

  // Ignore when Glance converts the image to RAW format
  lifecycle {
    ignore_changes = [
      disk_format
    ]
  }
}

resource "openstack_images_image_v2" "fcos_43_2025_11_20" {
  name             = "Fedora CoreOS 43 (2025.11.20)"
  image_source_url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/43.20251120.3.0/x86_64/fedora-coreos-43.20251120.3.0-openstack.x86_64.qcow2.xz"

  container_format = "bare"
  disk_format      = "qcow2"
  decompress       = true
  min_disk_gb      = 10
  min_ram_mb       = 1536
  visibility       = var.environment == "prod" ? "public" : "private"

  properties = {
    architecture  = "x86_64"
    os_type       = "linux"
    os_distro     = "fedora-coreos"
    os_version    = "43"
    os_admin_user = "core"

    cinder_img_volume_type = "PREMIUM"
  }

  // Ignore when Glance converts the image to RAW format
  lifecycle {
    ignore_changes = [
      disk_format
    ]
  }
}
