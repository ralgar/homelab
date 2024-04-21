data "ignition_filesystem" "data" {
  path            = "/var/srv"
  device          = "/dev/vdb"
  format          = "xfs"
  wipe_filesystem = false
}

data "ignition_systemd_unit" "mount_data" {
  name    = "var-srv.mount"
  content = file("${path.module}/files/var-srv.mount")
}

data "ignition_filesystem" "storage" {
  path            = "/var/mnt"
  device          = "/dev/vdc"
  format          = "xfs"
  wipe_filesystem = false
}

data "ignition_systemd_unit" "mount_storage" {
  name    = "var-mnt.mount"
  content = file("${path.module}/files/var-mnt.mount")
}
