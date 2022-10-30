terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
    }
    local = {
      source = "hashicorp/local"
    }
    remote = {
      source = "tenstad/remote"
      version = "0.1.1"
    }
  }
}
