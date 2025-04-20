resource "openstack_images_image_v2" "rocky_9_2024_11_18" {
  name             = "Rocky Linux 9.5 (2024.11.18)"
  image_source_url = "https://dl.rockylinux.org/vault/rocky/9.5/images/x86_64/Rocky-9-GenericCloud-Base-9.5-20241118.0.x86_64.qcow2"

  container_format = "bare"
  disk_format      = "qcow2"
  web_download     = true
  min_disk_gb      = 10
  min_ram_mb       = 1536
  visibility       = var.environment == "prod" ? "public" : "private"

  properties = {
    architecture  = "x86_64"
    os_type       = "linux"
    os_distro     = "rocky"
    os_version    = "9.5"
    os_admin_user = "rocky"

    cinder_img_volume_type = "PREMIUM"
  }

  // Ignore when Glance converts the image to RAW format
  lifecycle {
    ignore_changes = [
      disk_format
    ]
  }
}
