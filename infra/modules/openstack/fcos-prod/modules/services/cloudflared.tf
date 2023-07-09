data "ignition_directory" "cloudflared" {
  path      = "/srv/cloudflared"
  uid       = 8080
  gid       = 8080
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "cloudflared" {
  name    = "cloudflared.service"
  content = file("${path.module}/files/cloudflared.service")
}
