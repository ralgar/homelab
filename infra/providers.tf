terraform {
  required_version = ">= 1.0.0"
  backend "http" {}
  required_providers {
    kubectl = { source  = "gavinbunney/kubectl" }
    proxmox = { source  = "telmate/proxmox" }
  }
}

provider "kubectl" {
  host                   = "${module.k3s-master.ipv4_address}:6443"
  client_certificate     = module.k3s-master.client_certificate
  client_key             = module.k3s-master.client_key
  cluster_ca_certificate = module.k3s-master.cluster_ca_certificate
  load_config_file       = false
}

provider "proxmox" {
  pm_api_url          = "https://${local.pve_host}:8006/api2/json"
  pm_api_token_id     = local.pve_api_token_id
  pm_api_token_secret = local.pve_api_token_secret
  pm_tls_insecure     = local.pve_tlsInsecure
  pm_timeout          = 600
}
