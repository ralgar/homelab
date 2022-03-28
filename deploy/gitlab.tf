module "gitlab" {
  // Guest Settings
  source      = "./lxc-container"
  hostname    = "gitlab"
  title       = "GitLab"
  description = <<-EOT
    Self-hosted Git repository, and DevOps tools.
  EOT
  count       = 1
  countIndex  = count.index
  cores       = 2
  memory      = 4096
  swap        = 2048
  rootSize    = 20
  startOnBoot = true
  startOrder  = "order=4,up=60"
  addToDns    = true
  dnsWildcard = true
  tags        = [ "gitlab-all", "gitlab-server", "prod" ]

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

module "gitlab-runner" {
  // Guest Settings
  source      = "./qemu-vm"
  hostname    = "gitlab-runner"
  title       = "GitLab Runner"
  description = <<-EOT
    GitLab CI Pipeline Runner
  EOT
  count       = 1
  countIndex  = count.index
  cores       = 2
  sockets     = 1
  memory      = 4096
  rootSize    = 20
  auxDisk     = true
  auxDiskSize = 8
  startOnBoot = true
  addToDns    = true
  dnsWildcard = false
  tags        = [ "gitlab-all", "gitlab-runner" ]

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
