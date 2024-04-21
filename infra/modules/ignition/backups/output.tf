data "ignition_config" "output" {
  files = [
    data.ignition_file.backup_script.rendered,
    data.ignition_file.etc_environment.rendered,
    data.ignition_file.etc_profiled_restic.rendered,
    data.ignition_file.rclone_config.rendered,
    data.ignition_file.restic_password.rendered,
  ]

  systemd = [
    data.ignition_systemd_unit.packages.rendered,
    data.ignition_systemd_unit.restic_service.rendered,
    data.ignition_systemd_unit.restic_timer.rendered,
  ]
}

output "ignition_config" {
  value = base64encode(data.ignition_config.output.rendered)
}
