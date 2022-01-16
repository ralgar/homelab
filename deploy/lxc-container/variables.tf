variable "addToDns" {
  description = "Whether to add resource to the DNS zones"
  type        = bool
}

variable "countIndex" {
  description = "Passthrough index of count"
  type        = number
}

variable "cores" {
  description = "Assign CPU cores"
  type        = number
}

variable "description" {
  description = "A description of the resource"
  type        = string
}

variable "dnsHostNums" {
  description = "List of hostnumbers for the DNS servers (IPv4 4th octet values)"
  type        = list(number)
}

variable "dnsSecretKey" {
  description = "An hmac secret key for DNS zone updates"
  type        = string
  sensitive   = true
}

variable "dnsSecretType" {
  description = "Secret key hash type. Ex. hmac-sha256"
  type        = string
}

variable "guestCtImage" {
  description = "Guest container image"
  type        = string
}

variable "guestPubKeyFile" {
  description = "Path to the SSH public key file"
  type        = string
  sensitive   = true
}

variable "guestStoragePool" {
  description = "Proxmox storage pool for the guest"
  type        = string
}

variable "guestTargetNode" {
  description = "Proxmox target node for the guest"
  type        = string
}

variable "guestVmTemplate" {
  description = "Guest container image"
  type        = string
}

variable "hostname" {
  description = "The hostname of the guest"
  type        = string
}

variable "memory" {
  description = "Allocate memory in MB"
  type        = number
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
  description = "IPv4 address of the network gateway"
  type        = string
}

variable "netHostNums" {
  description = "List of network host numbers. Dynamically changes instance count."
  type        = list(number)
}

variable "netPrefix" {
  description = "Network prefix (CIDR notation)"
  type        = string
}

variable "pveHost" {
  description = "Proxmox host FQDN or IPv4 address"
  type        = string
}

variable "pveUsername" {
  description = "Proxmox VE username"
  type        = string
  sensitive   = true
}

variable "pvePassword" {
  description = "Proxmox VE password"
  type        = string
  sensitive   = true
}

variable "pveTlsInsecure" {
  description = "Toggle whether TLS must be validated"
  type        = bool
}

variable "startOnBoot" {
  description = "Always start the container when host boots"
  type        = bool
}

variable "rootSize" {
  description = "Allocate rootfs disk space in GB"
  type        = number
}

variable "swap" {
  description = "Allocate swap in MB"
  type        = number
}

variable "tags" {
  description = "A list of tags for the instance(s)"
  type        = list(string)
}

variable "title" {
  description = "Title/Heading of the resource in Proxmox notes"
  type        = string
}
