terraform {
  required_providers {
    dns = {
      source  = "hashicorp/dns"
    }
    proxmox = {
      source  = "telmate/proxmox"
    }
  }
}
