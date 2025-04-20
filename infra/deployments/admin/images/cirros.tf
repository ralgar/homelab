resource "openstack_images_image_v2" "cirros_0_6_2" {
  name             = "CirrOS v0.6.2"
  image_source_url = "https://download.cirros-cloud.net/0.6.2/cirros-0.6.2-x86_64-disk.img"

  container_format = "bare"
  disk_format      = "qcow2"
  web_download     = true
  min_disk_gb      = 1
  min_ram_mb       = 512
  visibility       = var.environment == "prod" ? "public" : "private"

  properties = {
    architecture  = "x86_64"
    os_type       = "linux"
    os_distro     = "cirros"
    os_version    = "0.6.2"
    os_admin_user = "cirros"

    cinder_img_volume_type = "PREMIUM"
  }

  // Ignore when Glance converts the image to RAW format
  lifecycle {
    ignore_changes = [
      disk_format
    ]
  }
}
