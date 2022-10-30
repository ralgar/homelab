variable "varsFile" {
  description = "Path to the YAML variables file"
  type        = string
  default     = "../vars/secret.yml"
}

locals {
  root = yamldecode(file(var.varsFile))

  // Proxmox Authentication
  pve_host             = sensitive(local.root.proxmox.host)
  pve_api_token_id     = sensitive(local.root.proxmox.apiTokenID)
  pve_api_token_secret = sensitive(local.root.proxmox.apiTokenSecret)
  pve_tlsInsecure      = local.root.proxmox.tlsInsecure

  // Global Guest Settings
  guest_pubKeyFile = local.root.globalVars.ssh.pubKeyFile
  net_dnsServers   = sensitive(local.root.globalVars.net.dnsServers)
  net_domain       = sensitive(local.root.globalVars.net.domainRoot)
  net_gateway      = sensitive(local.root.globalVars.net.gateway)

  // K3s Node Settings
  k3s_controllerNodes = local.root.k3s.controller.nodes
  k3s_workerNodes     = local.root.k3s.worker.nodes

  // SSH Authentication Settings
  ssh_privateKeyFile = local.ssh_useLocalAgent? null :local.root.globalVars.ssh.privateKeyFile
  ssh_useLocalAgent  = local.root.globalVars.ssh.useLocalAgent
}
