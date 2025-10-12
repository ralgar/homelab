data "ignition_config" "output" {
  files = concat(
    [
      data.ignition_file.hostname.rendered,
      data.ignition_file.zincati_updates.rendered,
    ],
    [for quadlet in data.ignition_file.quadlets : quadlet.rendered]
  )

  filesystems = [
    data.ignition_filesystem.container_storage.rendered,
  ]

  links = [
    data.ignition_link.timezone.rendered,
  ]

  systemd = [
    data.ignition_systemd_unit.containers_target.rendered,
    data.ignition_systemd_unit.mount_container_storage.rendered,
    data.ignition_systemd_unit.podman_auto_update_service.rendered,
    data.ignition_systemd_unit.podman_auto_update_timer.rendered,
  ]

  users = [
    data.ignition_user.core.rendered,
  ]
}

output "ignition_config" {
  value = base64encode(data.ignition_config.output.rendered)
}
