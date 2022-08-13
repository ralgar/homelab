variable "varsFile" {
  description = "Path to the YAML variables file"
  type        = string
  default     = "../vars/secret.yml"
}

local "root" {
  expression = yamldecode(file(var.varsFile))
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
