terraform {
  required_providers {
    dns = {
      source  = "hashicorp/dns"
      version = "3.2.1"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

provider "dns" {
  update {
    server        = cidrhost(var.net_prefix, var.dns_hostNums[0])
    key_name      = "${var.net_domain}."
    key_algorithm = var.dns_secretType
    key_secret    = var.dns_secretKey
  }
}

provider "proxmox" {
  pm_api_url      = "${var.pve_host}/api2/json"
  pm_user         = "${var.pve_username}"
  pm_password     = var.pve_password
  pm_tls_insecure = var.pve_tlsInsecure
}
