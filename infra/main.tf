module "k3s-master" {
  // Module Settings
  source           = "./k3s-master"
  guestTargetNode  = local.k3s_controllerNodes[0].pve_node
  guestStoragePool = local.k3s_controllerNodes[0].pve_storage_pool
  guestIPAddr      = local.k3s_controllerNodes[0].ip_addr

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain
  netGateway      = local.net_gateway
}

module "k3s-controllers" {
  // Module Settings
  source           = "./k3s-controller"
  for_each         = { for k, v in local.k3s_controllerNodes: k => v if ! (k == "0") }
  guestNumber      = each.key
  guestTargetNode  = each.value.pve_node
  guestStoragePool = each.value.pve_storage_pool
  guestIPAddr      = each.value.ip_addr

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain
  netGateway      = local.net_gateway
}

module "k3s-workers" {
  // Module Settings
  source           = "./k3s-worker"
  for_each         = local.k3s_workerNodes
  guestNumber      = each.key
  guestTargetNode  = each.value.pve_node
  guestStoragePool = each.value.pve_storage_pool
  guestIPAddr      = each.value.ip_addr

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain
  netGateway      = local.net_gateway

  depends_on      = [ module.k3s-controllers ]
}
