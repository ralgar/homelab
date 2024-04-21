data "ignition_directory" "hass" {
  path      = "/srv/hass"
  uid       = 9024
  gid       = 9024
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "hass" {
  name    = "hass.service"
  content = file("${path.module}/files/hass.service")
}
