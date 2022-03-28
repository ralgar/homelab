module "nameservers" {
  // Guest Settings
  source      = "./lxc-container"
  hostname    = "ns${count.index + 1}"
  title       = "Name Server #${count.index + 1 }"
  description = <<-EOT
    A recursive DNS server powered by BIND.
  EOT
  count       = length(var.guest_hostNums)
  countIndex  = count.index
  cores       = 1
  memory      = 256
  swap        = 256
  rootSize    = 8
  startOnBoot = true
  startOrder  = "order=1"
  addToDns    = false
  dnsWildcard = false
  tags        = [ "nameservers", "prod" ]

  // Global Passthrough Variables
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
    "1.1.1.1",
    "1.0.0.1"
  ]
  netDomain        = var.net_domain
  netGateway       = var.net_gateway
  netPrefix        = var.net_prefix

  // Module Variables
  netHostNums      = var.guest_hostNums
}
