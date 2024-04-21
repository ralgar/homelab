data "ignition_systemd_unit" "packages" {
  name    = "packages.service"
  content = file("${path.module}/files/packages.service")
}
