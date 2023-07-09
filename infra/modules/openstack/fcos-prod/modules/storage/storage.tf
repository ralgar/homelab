data "ignition_filesystem" "storage" {
  path            = "/var/mnt"
  device          = "/dev/vdc"
  format          = "xfs"
  wipe_filesystem = false
}

data "ignition_systemd_unit" "storage" {
  name    = "var-mnt.mount"
  content = file("${path.module}/files/var-mnt.mount")
}
