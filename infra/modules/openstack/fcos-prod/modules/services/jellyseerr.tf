data "ignition_directory" "jellyseerr" {
  path      = "/srv/jellyseerr"
  uid       = 9025
  gid       = 9030
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "jellyseerr" {
  name    = "jellyseerr.service"
  content = file("${path.module}/files/jellyseerr.service")
}
