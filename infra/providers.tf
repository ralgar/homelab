terraform {
  required_version = ">= 1.0.0"
  backend "http" {}
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.6.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = "${module.k3s-master.ipv4_address}:6443"
    client_certificate     = module.k3s-master.client_certificate
    client_key             = module.k3s-master.client_key
    cluster_ca_certificate = module.k3s-master.cluster_ca_certificate
  }
}

provider "proxmox" {
  pm_api_url          = "https://${local.pve_host}:8006/api2/json"
  pm_api_token_id     = local.pve_api_token_id
  pm_api_token_secret = local.pve_api_token_secret
  pm_tls_insecure     = local.pve_tlsInsecure
  pm_timeout          = 600
}
