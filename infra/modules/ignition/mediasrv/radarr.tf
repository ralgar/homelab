data "ignition_directory" "radarr" {
  path      = "/srv/radarr"
  uid       = 9032
  gid       = 9030
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "radarr" {
  name    = "radarr.service"
  content = file("${path.module}/files/radarr.service")
  enabled = false
}
