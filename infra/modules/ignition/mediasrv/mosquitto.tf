data "ignition_directory" "mosquitto" {
  path      = "/srv/mosquitto"
  uid       = 1883
  gid       = 1883
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "mosquitto" {
  name    = "mosquitto.service"
  content = file("${path.module}/files/mosquitto.service")
  enabled = false
}
