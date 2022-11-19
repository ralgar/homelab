terraform {
  required_version = ">= 1.0.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    remote = {
      source  = "tenstad/remote"
      version = "0.1.1"
    }
  }
}
