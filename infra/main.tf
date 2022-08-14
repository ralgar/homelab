module "k3s-master" {
  // Module Settings
  source           = "./k3s-master"
  guestTargetNode  = "pve1"
  guestStoragePool = "local-zfs"

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain
}

module "k3s-controllers" {
  // Module Settings
  source           = "./k3s-controller"
  replicas         = 0
  guestTargetNode  = "pve1"
  guestStoragePool = "local-zfs"

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain
}

module "k3s-workers" {
  // Module Settings
  source           = "./k3s-worker"
  replicas         = 2
  guestTargetNode  = "pve1"
  guestStoragePool = "local-zfs"

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain

  depends_on      = [ module.k3s-controllers ]
}
