output "directories" {
  value = [
    data.ignition_directory.cloudflared.rendered,
    data.ignition_directory.hass.rendered,
    data.ignition_directory.jellyfin.rendered,
    data.ignition_directory.jellyseerr.rendered,
    data.ignition_directory.mosquitto.rendered,
    data.ignition_directory.nzbget.rendered,
    data.ignition_directory.prowlarr.rendered,
    data.ignition_directory.radarr.rendered,
    data.ignition_directory.sonarr.rendered,
    data.ignition_directory.swag.rendered,
  ]
}

output "systemd" {
  value = [
    data.ignition_systemd_unit.cloudflared.rendered,
    data.ignition_systemd_unit.hass.rendered,
    data.ignition_systemd_unit.jellyfin.rendered,
    data.ignition_systemd_unit.jellyseerr.rendered,
    data.ignition_systemd_unit.mosquitto.rendered,
    data.ignition_systemd_unit.nzbget.rendered,
    data.ignition_systemd_unit.podman_auto_update_service.rendered,
    data.ignition_systemd_unit.podman_auto_update_timer.rendered,
    data.ignition_systemd_unit.prowlarr.rendered,
    data.ignition_systemd_unit.radarr.rendered,
    data.ignition_systemd_unit.sonarr.rendered,
    data.ignition_systemd_unit.swag.rendered,
  ]
}
