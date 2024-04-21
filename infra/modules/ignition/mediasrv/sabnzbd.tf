data "ignition_directory" "sabnzbd" {
  path      = "/srv/sabnzbd"
  uid       = 9030
  gid       = 9030
  mode      = 448
  overwrite = false
}

data "ignition_directory" "usenet" {
  path      = "/mnt/usenet"
  uid       = 9030
  gid       = 9030
  mode      = 504
  overwrite = false
}

data "ignition_systemd_unit" "sabnzbd" {
  name    = "sabnzbd.service"
  content = file("${path.module}/files/sabnzbd.service")
}
