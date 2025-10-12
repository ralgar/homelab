data "ignition_systemd_unit" "containers_target" {
  name    = "containers.target"
  content = file("${path.module}/files/containers.target")
}

data "ignition_file" "quadlets" {
  for_each = var.quadlets

  path = "/etc/containers/systemd/${basename(each.key)}"

  content {
    content = templatefile(each.key, each.value)
  }
}
