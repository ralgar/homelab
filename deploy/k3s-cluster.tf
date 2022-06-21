module "k3s-master" {
  // Guest Settings
  source      = "./qemu-vm"
  hostname    = "k3s-master"
  title       = "K3s Master Node"
  description = <<-EOT
    K3S Master Node. The source of truth.
  EOT
  count           = length(var.guest_hostNums)
  countIndex      = count.index
  cores           = 2
  sockets         = 1
  memory          = 2048
  enableQemuAgent = 1
  rootSize        = 8
  auxDisk         = false
  auxDiskSize     = null
  startOnBoot     = true
  addToDns        = true
  dnsWildcard     = false
  tags            = [ "k3s-cluster", "k3s-master" ]

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
    "${cidrhost(var.net_prefix, var.dns_hostNums[1])}",
    "1.1.1.1",
  ]
  netDomain        = var.net_domain
  netGateway       = var.net_gateway
  netPrefix        = var.net_prefix

  // Module Variables
  netHostNums      = var.guest_hostNums
}

module "k3s-worker" {
  // Guest Settings
  source      = "./qemu-vm"
  hostname    = "k3s-worker-${count.index + 1}"
  title       = "K3s Worker Node #${count.index + 1 }"
  description = <<-EOT
    A K3s worker node. Runs services.
  EOT
  count           = length(var.guest_hostNums)
  countIndex      = count.index
  cores           = 4
  sockets         = 1
  memory          = 8192
  enableQemuAgent = 1
  rootSize        = 64
  auxDisk         = false
  auxDiskSize     = null
  startOnBoot     = true
  addToDns        = true
  dnsWildcard     = false
  tags            = [ "k3s-cluster", "k3s-worker" ]

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
    "${cidrhost(var.net_prefix, var.dns_hostNums[1])}",
    "1.1.1.1",
  ]
  netDomain        = var.net_domain
  netGateway       = var.net_gateway
  netPrefix        = var.net_prefix

  // Module Variables
  netHostNums      = var.guest_hostNums
}
