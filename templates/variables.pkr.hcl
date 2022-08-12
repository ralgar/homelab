local "root" {
  expression = yamldecode(file("../vars/secret.yml"))
}

local "pve_host" {
  expression = "${local.root.proxmox.host}"
  sensitive  = true
}

local "pve_api_token_id" {
  expression = "${local.root.proxmox.apiTokenID}"
  sensitive  = true
}

local "pve_api_token_secret" {
  expression = "${local.root.proxmox.apiTokenSecret}"
  sensitive  = true
}

local "pve_tlsInsecure" {
  expression = "${local.root.proxmox.tlsInsecure}"
}
