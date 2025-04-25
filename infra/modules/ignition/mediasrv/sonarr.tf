data "ignition_directory" "sonarr" {
  path      = "/srv/sonarr"
  uid       = 9033
  gid       = 9030
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "sonarr" {
  name    = "sonarr.service"
  content = file("${path.module}/files/sonarr.service")
  enabled = false
}
