data "ignition_file" "restic_password" {
  path = "/root/restic-password"
  mode = 384
  content {
    content = templatefile("${path.module}/templates/restic-password", {
      restic_password = var.restic_password
    })
  }
}

data "ignition_file" "backup_script" {
  path = "/usr/local/bin/backup.sh"
  mode = 493
  content {
    content = file("${path.module}/files/backup.sh")
  }
}

data "ignition_file" "etc_environment" {
  path      = "/etc/environment"
  mode      = 420
  overwrite = true
  content {
    content = file("${path.module}/files/environment")
  }
}

data "ignition_file" "etc_profiled_restic" {
  path      = "/etc/profile.d/restic.sh"
  mode      = 420
  overwrite = true
  content {
    content = file("${path.module}/files/environment")
  }
}

data "ignition_systemd_unit" "restic_service" {
  name    = "restic.service"
  enabled = false
  content = file("${path.module}/files/restic.service")
}

data "ignition_systemd_unit" "restic_timer" {
  name    = "restic.timer"
  content = file("${path.module}/files/restic.timer")
}
