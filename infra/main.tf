module "k3s-master" {
  // Module Settings
  source            = "./k3s-master"
  guestTargetNode   = local.k3s_controllerNodes[0].pve_node
  guestStoragePool  = local.k3s_controllerNodes[0].pve_storage_pool
  guestIPAddr       = local.k3s_controllerNodes[0].ip_addr
  guestCores        = local.k3s_controllerNodes[0].cores
  guestVCPUs        = local.k3s_controllerNodes[0].vcpus
  guestMemory       = local.k3s_controllerNodes[0].memory
  sshUseLocalAgent  = local.ssh_useLocalAgent
  sshPrivateKeyFile = local.ssh_privateKeyFile

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
  guestCores       = each.value.cores
  guestVCPUs       = each.value.vcpus
  guestMemory      = each.value.memory

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain
  netGateway      = local.net_gateway

  depends_on      = [ module.k3s-master ]
}

module "k3s-workers" {
  // Module Settings
  source           = "./k3s-worker"
  for_each         = local.k3s_workerNodes
  guestNumber      = each.key
  guestTargetNode  = each.value.pve_node
  guestStoragePool = each.value.pve_storage_pool
  guestIPAddr      = each.value.ip_addr
  guestCores       = each.value.cores
  guestVCPUs       = each.value.vcpus
  guestMemory      = each.value.memory

  // Global Variables
  guestPubKeyFile = local.guest_pubKeyFile
  netDnsHosts     = local.net_dnsServers
  netDomain       = local.net_domain
  netGateway      = local.net_gateway

  depends_on      = [
    module.k3s-master,
    module.k3s-controllers
  ]
}

resource "time_sleep" "wait_for_nodes" {
  create_duration = "60s"
  depends_on      = [
    module.k3s-master,
    module.k3s-controllers,
    module.k3s-workers
  ]
}

resource "helm_release" "argocd" {
  name              = "argocd"
  chart             = "${path.root}/../cluster/system/argocd"
  dependency_update = true
  namespace         = "argocd"
  create_namespace  = true
  atomic            = true

  depends_on        = [ time_sleep.wait_for_nodes ]
}
