data "ignition_directory" "swag" {
  path      = "/srv/swag"
  uid       = 8443
  gid       = 8443
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "swag" {
  name    = "swag.service"
  content = file("${path.module}/files/swag.service")
}
