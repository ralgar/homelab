resource "openstack_blockstorage_volume_v3" "media" {
  name        = "media"
  description = "Media server storage volume."
  volume_type = "__DEFAULT__"
  size        = 6000

  enable_online_resize = true
}

data "ignition_filesystem" "media_storage" {
  path            = "/var/mnt"
  device          = "/dev/vdc"
  format          = "xfs"
  wipe_filesystem = false
}

data "ignition_systemd_unit" "mount_media_storage" {
  name    = "var-mnt.mount"
  content = file("${path.module}/files/var-mnt.mount")
}

data "ignition_directory" "var_mnt_library" {
  path      = "/var/mnt/library"
  uid       = 9030
  gid       = 9030
  mode      = 504
  overwrite = false
}

data "ignition_directory" "var_mnt_usenet" {
  path      = "/var/mnt/usenet"
  uid       = 9030
  gid       = 9030
  mode      = 504
  overwrite = false
}

data "ignition_config" "additional_storage" {
  directories = [
    data.ignition_directory.var_mnt_library.rendered,
    data.ignition_directory.var_mnt_usenet.rendered,
  ]
  filesystems = [
    data.ignition_filesystem.media_storage.rendered,
  ]
  systemd = [
    data.ignition_systemd_unit.mount_media_storage.rendered,
  ]
}
