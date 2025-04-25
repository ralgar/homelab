data "ignition_directory" "jellyfin" {
  path      = "/srv/jellyfin"
  uid       = 9023
  gid       = 9023
  mode      = 448
  overwrite = false
}

data "ignition_directory" "library" {
  path      = "/mnt/library"
  uid       = 9030
  gid       = 9030
  mode      = 504
  overwrite = false
}

data "ignition_systemd_unit" "jellyfin" {
  name    = "jellyfin.service"
  content = file("${path.module}/files/jellyfin.service")
  enabled = false
}
