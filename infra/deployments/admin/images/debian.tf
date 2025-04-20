resource "openstack_images_image_v2" "debian_12_2025_03_16" {
  name             = "Debian 12 (2025.03.16)"
  image_source_url = "https://cloud.debian.org/images/cloud/bookworm/20250316-2053/debian-12-genericcloud-amd64-20250316-2053.qcow2"

  container_format = "bare"
  disk_format      = "qcow2"
  web_download     = true
  min_disk_gb      = 4
  min_ram_mb       = 512
  visibility       = var.environment == "prod" ? "public" : "private"

  properties = {
    architecture  = "x86_64"
    os_type       = "linux"
    os_distro     = "debian"
    os_version    = "12"
    os_admin_user = "debian"

    cinder_img_volume_type = "PREMIUM"
  }

  // Ignore when Glance converts the image to RAW format
  lifecycle {
    ignore_changes = [
      disk_format
    ]
  }
}
