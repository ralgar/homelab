data "ignition_directory" "jellyfin" {
  path      = "/srv/jellyfin"
  uid       = 9023
  gid       = 9023
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "jellyfin" {
  name    = "jellyfin.service"
  content = file("${path.module}/files/jellyfin.service")
}
