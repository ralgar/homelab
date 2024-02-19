output "files" {
  value = [
    data.ignition_file.zincati_updates.rendered,
  ]
}

output "links" {
  value = [
    data.ignition_link.timezone.rendered,
  ]
}
