resource "openstack_images_image_v2" "ubuntu_2404_2025_04_03" {
  name             = "Ubuntu 24.04 LTS (2025.04.03)"
  image_source_url = "https://cloud-images.ubuntu.com/noble/20250403/noble-server-cloudimg-amd64.img"

  container_format = "bare"
  disk_format      = "qcow2"
  web_download     = true
  min_disk_gb      = 4
  min_ram_mb       = 1024
  visibility       = var.environment == "prod" ? "public" : "private"

  properties = {
    architecture  = "x86_64"
    os_type       = "linux"
    os_distro     = "ubuntu"
    os_version    = "24.04"
    os_admin_user = "ubuntu"

    cinder_img_volume_type = "PREMIUM"
  }
}
