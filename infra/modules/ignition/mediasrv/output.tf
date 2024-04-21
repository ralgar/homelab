data "ignition_config" "output" {
  directories = [
    data.ignition_directory.hass.rendered,
    data.ignition_directory.jellyfin.rendered,
    data.ignition_directory.jellyseerr.rendered,
    data.ignition_directory.library.rendered,
    data.ignition_directory.mosquitto.rendered,
    data.ignition_directory.prowlarr.rendered,
    data.ignition_directory.radarr.rendered,
    data.ignition_directory.sabnzbd.rendered,
    data.ignition_directory.sonarr.rendered,
    data.ignition_directory.swag.rendered,
    data.ignition_directory.usenet.rendered,
  ]

  filesystems = [
    data.ignition_filesystem.data.rendered,
    data.ignition_filesystem.storage.rendered,
  ]

  systemd = [
    data.ignition_systemd_unit.hass.rendered,
    data.ignition_systemd_unit.jellyfin.rendered,
    data.ignition_systemd_unit.jellyseerr.rendered,
    data.ignition_systemd_unit.mosquitto.rendered,
    data.ignition_systemd_unit.mount_data.rendered,
    data.ignition_systemd_unit.mount_storage.rendered,
    data.ignition_systemd_unit.networks.rendered,
    data.ignition_systemd_unit.podman_auto_update_service.rendered,
    data.ignition_systemd_unit.podman_auto_update_timer.rendered,
    data.ignition_systemd_unit.prowlarr.rendered,
    data.ignition_systemd_unit.radarr.rendered,
    data.ignition_systemd_unit.sabnzbd.rendered,
    data.ignition_systemd_unit.sonarr.rendered,
    data.ignition_systemd_unit.swag.rendered,
  ]
}

output "ignition_config" {
  value = base64encode(data.ignition_config.output.rendered)
}
