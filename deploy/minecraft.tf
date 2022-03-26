module "minecraft-servers" {
  // Guest Settings
  source      = "./qemu-vm"
  hostname    = "minecraft-${count.index + 1}"
  title       = "Minecraft Server #${count.index + 1 }"
  description = <<-EOT
    A production-ready Minecraft server.
  EOT
  count       = length(var.guest_hostNums)
  countIndex  = count.index
  cores       = 2
  sockets     = 1
  memory      = 4096
  rootSize    = 20
  startOnBoot = false
  addToDns    = true
  dnsWildcard = false
  tags        = [ "minecraft", "prod" ]

  // Global Variables
  dnsHostNums      = var.dns_hostNums
  dnsSecretKey     = var.dns_secretKey
  dnsSecretType    = var.dns_secretType
  pveHost          = var.pve_host
  pveUsername      = var.pve_username
  pvePassword      = var.pve_password
  pveTlsInsecure   = var.pve_tlsInsecure
  guestCtImage     = var.guest_ctImage
  guestPubKeyFile  = var.guest_pubKeyFile
  guestTargetNode  = var.guest_targetNode
  guestStoragePool = var.guest_storagePool
  guestVmTemplate  = var.guest_vmTemplate
  netDnsHosts      = [
    "${cidrhost(var.net_prefix, var.dns_hostNums[0])}",
    "${cidrhost(var.net_prefix, var.dns_hostNums[1])}",
    "1.1.1.1"
  ]
  netDomain        = var.net_domain
  netGateway       = var.net_gateway
  netPrefix        = var.net_prefix

  // Module Variables
  netHostNums      = var.guest_hostNums
}
