variable "guest_pubKeyFile" {
  description = "Required: Path to the SSH public key file"
  type        = string
  sensitive   = true
}

variable "net_dnsServers" {
  description = "Optional: List of DNS server IP addresses."
  type        = list(string)
  default     = [ "" ]
}

variable "net_domain" {
  description = "Optional: DNS root domain"
  type        = string
  default     = ""
  sensitive   = true
}

variable "pve_host" {
  description = "Required: IP address or FQDN of a Proxmox host in your cluster."
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
