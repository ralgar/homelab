data "ignition_directory" "nzbget" {
  path      = "/srv/nzbget"
  uid       = 9030
  gid       = 9030
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "nzbget" {
  name    = "nzbget.service"
  content = file("${path.module}/files/nzbget.service")
}
