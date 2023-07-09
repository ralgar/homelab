data "ignition_disk" "root" {
  device     = "/dev/disk/by-id/coreos-boot-disk"
  wipe_table = false

  // Allocate minimum 8 GiB to rootfs for updates
  partition {
    label    = "root"
    number   = 4
    sizemib = 8192
  }

  // Allocate whatever remains of the root disk for container storage
  partition {
    label   = "containers"
    sizemib = 0
  }
}

data "ignition_filesystem" "containers" {
  path            = "/var/lib/containers"
  device          = "/dev/disk/by-partlabel/containers"
  format          = "xfs"
  wipe_filesystem = false
}

data "ignition_systemd_unit" "containers" {
  name    = "var-lib-containers.mount"
  content = file("${path.module}/files/var-lib-containers.mount")
}
