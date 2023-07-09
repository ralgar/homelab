output "users" {
  value = [
    data.ignition_user.core.rendered,
  ]
}
