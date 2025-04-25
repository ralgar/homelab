data "ignition_systemd_unit" "containers" {
  name    = "containers.target"
  content = file("${path.module}/files/containers.target")
}
