locals {
  root = yamldecode(file("../vars/secret.yml"))

  // Proxmox Authentication
  pve_host             = sensitive(local.root.proxmox.host)
  pve_api_token_id     = sensitive(local.root.proxmox.apiTokenID)
  pve_api_token_secret = sensitive(local.root.proxmox.apiTokenSecret)
  pve_tlsInsecure      = local.root.proxmox.tlsInsecure

  // Global Guest Settings
  guest_pubKeyFile = sensitive(local.root.globalVars.ssh.pubKeyFile)
  net_dnsServers   = sensitive(local.root.globalVars.net.dnsServers)
  net_domain       = sensitive(local.root.globalVars.net.domainRoot)
}
