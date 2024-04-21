data "ignition_file" "zincati_updates" {
  path = "/etc/zincati/config.d/90-updates.toml"
  content {
    content = file("${path.module}/files/zincati-updates.toml")
  }
}
