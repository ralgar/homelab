data "ignition_directory" "swag" {
  path      = "/srv/swag"
  uid       = 8443
  gid       = 8443
  mode      = 448
  overwrite = false
}

data "ignition_systemd_unit" "swag" {
  name    = "swag.service"
  content = templatefile("${path.module}/templates/swag.service", {
    domain      = var.domain
    staging     = var.environment == "staging" ? "true" : "false"
  })
  enabled = false
}
