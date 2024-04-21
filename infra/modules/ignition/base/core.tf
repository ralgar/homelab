// Default privileged user
data "ignition_user" "core" {
  name                = "core"
  ssh_authorized_keys = [var.keypair.public_key]

  # WARNING: HIGHLY insecure. Uncomment for debugging only. The password is 'password'.
  #password_hash = "$6$jKyIlQlYTvHR..Aa$3OYgIE/dENvHu6w68UdQ21MaudLpBrihxcASiLTgUySzMGEUeHRy0xayOCastf7Q27kS6qAxOpBQu1I/N5r1R/"
}
