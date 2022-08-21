variable "guestIPAddr" {
  description = "Static IP address of the guest"
  type        = string
}

variable "guestNumber" {
  description = "Numbered position in the list"
  type        = number
}

variable "guestPubKeyFile" {
  description = "Path to the SSH public key file"
  type        = string
}

variable "guestStoragePool" {
  description = "Proxmox storage pool for the guest"
  type        = string
}

variable "guestTargetNode" {
  description = "Proxmox target node for the guest"
  type        = string
}

variable "netDnsHosts" {
  description = "List of nameserver IPv4 addresses (DNS)"
  type        = list(string)
}

variable "netDomain" {
  description = "Local domain name (used for DNS)"
  type        = string
  sensitive   = true
}

variable "netGateway" {
  description = "Local network gateway"
  type        = string
}
