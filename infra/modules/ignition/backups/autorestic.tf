data "ignition_file" "autorestic_config" {
  path = "/root/.autorestic.yml"
  mode = 384
  content {
    content = templatefile("${path.module}/templates/autorestic.yml", {
      backblaze_bucket      = var.backblaze_bucket
      backblaze_account_id  = var.backblaze_account_id
      backblaze_account_key = var.backblaze_account_key
      restic_password       = var.restic_password
    })
  }
}

data "ignition_systemd_unit" "autorestic_service" {
  name    = "autorestic.service"
  enabled = false
  content = file("${path.module}/files/autorestic.service")
}

data "ignition_systemd_unit" "autorestic_timer" {
  name    = "autorestic.timer"
  content = file("${path.module}/files/autorestic.timer")
  enabled = var.environment == "prod" ? true : false
}
