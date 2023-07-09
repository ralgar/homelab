// Default privileged user
data "ignition_user" "core" {
  name                = "core"
  ssh_authorized_keys = [var.keypair.public_key]
}
