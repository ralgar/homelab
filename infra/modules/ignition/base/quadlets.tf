data "ignition_systemd_unit" "containers_target" {
  name    = "containers.target"
  content = templatefile("${path.module}/templates/containers.target", {
    units = [for path, _ in var.quadlets : basename(path) if endswith(path, ".container")]
  })
}

data "ignition_file" "quadlets" {
  for_each = var.quadlets

  path = "/etc/containers/systemd/${basename(each.key)}"

  content {
    content = templatefile(each.key, each.value)
  }
}
