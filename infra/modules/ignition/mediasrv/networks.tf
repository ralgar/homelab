data "ignition_systemd_unit" "networks" {
  name    = "podman-networks.service"
  content = file("${path.module}/files/podman-networks.service")
  enabled = false
}
