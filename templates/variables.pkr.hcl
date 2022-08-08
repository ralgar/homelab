variable "pve_host" {
  description = "Proxmox host FQDN or IPv4 address"
  type        = string
  sensitive   = true
}

variable "pve_api_token_id" {
  description = "Required: Proxmox API token ID (format: user@realm!token_name)."
  type        = string
  sensitive   = true
}

variable "pve_api_token_secret" {
  description = "Required: Proxmox API token secret (format is a UUID string)."
  type        = string
  sensitive   = true
}

variable "pve_tlsInsecure" {
  description = "Optional: Toggles TLS certificate validation."
  type        = bool
  default     = false
}
