output "filesystems" {
  value = [
    //data.ignition_filesystem.containers.rendered,
    data.ignition_filesystem.data.rendered,
    data.ignition_filesystem.storage.rendered,
  ]
}

output "systemd" {
  value = [
    //data.ignition_systemd_unit.containers.rendered,
    data.ignition_systemd_unit.data.rendered,
    data.ignition_systemd_unit.storage.rendered,
  ]
}
