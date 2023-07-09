data "ignition_directory" "prowlarr" {
  path      = "/srv/prowlarr"
  uid       = 9031
  gid       = 9030
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "prowlarr" {
  name    = "prowlarr.service"
  content = file("${path.module}/files/prowlarr.service")
}
