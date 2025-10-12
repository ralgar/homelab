data "ignition_filesystem" "container_storage" {
  device          = "/dev/vdb"
  path            = "/var/lib/containers/storage"
  format          = "xfs"
  wipe_filesystem = false
}

data "ignition_systemd_unit" "mount_container_storage" {
  name    = "var-lib-containers-storage.mount"
  content = file("${path.module}/files/container-storage.mount")
}
