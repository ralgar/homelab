resource "openstack_images_image_v2" "talos_1_9_5" {
  name             = "Talos v1.9.5"
  image_source_url = "https://factory.talos.dev/image/bb0ba48a52352c699781aeeb4aa1983b80ccc778c2eac94590fe6b4ab3c0fd00/v1.9.5/openstack-amd64.raw.xz"
  container_format = "bare"
  disk_format      = "raw"
  decompress       = true
  min_disk_gb      = 10
  min_ram_mb       = 2048

  properties = {
    architecture = "x86_64"
    os_type      = "linux"
    os_distro    = "talos"
    os_version   = "1.9.5"

    cinder_img_volume_type = "PREMIUM"

    hw_qemu_guest_agent = true
  }
}
