variable "dns_hostNums" {
  description = "List of hostnumbers for the DNS servers (IPv4 4th octet values)"
  type        = list(number)
}

variable "dns_secretKey" {
  description = "An hmac secret key for DNS zone updates"
  type        = string
  sensitive   = true
}

variable "dns_secretType" {
  description = "Secret key hash type. Ex. hmac-sha256"
  type        = string
}

variable "guest_ctImage" {
  description = "Guest container image"
  type        = string
}

variable "guest_hostNums" {
  description = "List of hostnumbers for the guest(s) (IPv4 4th octet value)"
  type        = list(number)
}

variable "guest_pubKeyFile" {
  description = "Path to the SSH public key file"
  type        = string
  sensitive   = true
}

variable "guest_storagePool" {
  description = "Proxmox storage pool for the guest"
  type        = string
}

variable "guest_targetNode" {
  description = "Proxmox target node for the guest"
  type        = string
}

variable "guest_vmTemplate" {
  description = "VM template to clone"
  type        = string
}

variable "net_domain" {
  description = "Desired domain (used for DNS search)"
  type        = string
  sensitive   = true
}

variable "net_gateway" {
  description = "Address of the gateway"
  type        = string
}

variable "net_prefix" {
  description = "Network prefix (CIDR notation)"
  type        = string
}

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
