data "ignition_filesystem" "data" {
  path            = "/var/srv"
  device          = "/dev/vdb"
  format          = "xfs"
  wipe_filesystem = false
}

data "ignition_systemd_unit" "data" {
  name    = "var-srv.mount"
  content = file("${path.module}/files/var-srv.mount")
}
