variable "pve_host" {
  description = "Proxmox host FQDN or IPv4 address"
  type        = string
}

variable "pve_username" {
  description = "Proxmox VE username"
  type        = string
  sensitive   = true
}

variable "pve_password" {
  description = "Proxmox VE password"
  type        = string
  sensitive   = true
}

variable "pve_tlsInsecure" {
  description = "Toggle whether TLS must be valid"
  type        = bool
}

variable "pve_token" {
  description = "Proxmox VE authentication token (if used)"
  type        = string
  sensitive   = true
}
