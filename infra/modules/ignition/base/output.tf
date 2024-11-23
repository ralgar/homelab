data "ignition_config" "output" {
  files = [
    data.ignition_file.hostname.rendered,
    data.ignition_file.zincati_updates.rendered,
  ]

  kernel_arguments = data.ignition_kernel_arguments.network_config.rendered

  links = [
    data.ignition_link.timezone.rendered,
  ]

  users = [
    data.ignition_user.core.rendered,
  ]
}

output "ignition_config" {
  value = base64encode(data.ignition_config.output.rendered)
}
