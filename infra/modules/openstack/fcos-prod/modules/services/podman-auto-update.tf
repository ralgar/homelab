data "ignition_systemd_unit" "podman_auto_update_timer" {
  name    = "podman-auto-update.timer"
  dropin {
    name = "custom-time.conf"
    content = <<-EOF
    [Timer]
    OnCalendar=
    OnCalendar=04:15:00
    RandomizedDelaySec=0
    EOF
  }
}

data "ignition_systemd_unit" "podman_auto_update_service" {
  name    = "podman-auto-update.service"
  enabled = false
  dropin {
    name = "after-restic.conf"
    content = <<-EOF
    [Unit]
    Wants=restic.service
    After=restic.service
    EOF
  }
}
