data "ignition_config" "output" {
  files = [
    data.ignition_file.autorestic_config.rendered,
  ]

  systemd = [
    data.ignition_systemd_unit.packages.rendered,
    data.ignition_systemd_unit.autorestic_service.rendered,
    data.ignition_systemd_unit.autorestic_timer.rendered,
  ]
}

output "ignition_config" {
  value = base64encode(data.ignition_config.output.rendered)
}
