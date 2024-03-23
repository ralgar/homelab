data "ignition_file" "hostname" {
  path = "/etc/hostname"
  content {
    content = "${var.domain}"
  }
}
