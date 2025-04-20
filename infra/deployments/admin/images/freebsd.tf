resource "openstack_images_image_v2" "freebsd_14_2_2024_12_08" {
  name             = "FreeBSD 14.2 (2024.12.08)"
  image_source_url = "https://object-storage.public.mtl1.vexxhost.net/swift/v1/1dbafeefbd4f4c80864414a441e72dd2/bsd-cloud-image.org/images/freebsd/14.2/2024-12-08/ufs/freebsd-14.2-ufs-2024-12-08.qcow2"

  container_format = "bare"
  disk_format      = "qcow2"
  web_download     = true
  min_disk_gb      = 4
  min_ram_mb       = 512
  visibility       = var.environment == "prod" ? "public" : "private"

  properties = {
    architecture  = "x86_64"
    os_type       = "linux"  # Only [linux,windows] so assume this covers all *nix?
    os_distro     = "freebsd"
    os_version    = "14.2"
    os_admin_user = "freebsd"

    cinder_img_volume_type = "PREMIUM"
  }

  // Ignore when Glance converts the image to RAW format
  lifecycle {
    ignore_changes = [
      disk_format
    ]
  }
}
