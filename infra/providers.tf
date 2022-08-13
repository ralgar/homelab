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
    config_path = "~/.kube/config"
  }
}

provider "proxmox" {
  pm_api_url          = "https://${local.pve_host}:8006/api2/json"
  pm_api_token_id     = local.pve_api_token_id
  pm_api_token_secret = local.pve_api_token_secret
  pm_tls_insecure     = local.pve_tlsInsecure
  pm_timeout          = 600
}
