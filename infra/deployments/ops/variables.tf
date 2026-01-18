variable "openstack_clouds_file" {
  description = "Path to OpenStack authentication file (clouds.yaml)"
  type        = string
}

variable "domain" {
  description = "A public domain that you own (ex: mydomain.com)"
  type        = string
  sensitive   = true
}

variable "deployment" {
  description = "Name of the deployment. Should correspond to the name of the current directory."
  type = string
}

variable "environment" {
  description = "Deployment environment (prod, staging, or dev)."
  type        = string
}

variable "management_network" {
  description = "A CIDR-notated management network from which to allow SSH (and other) access."
  type        = string
  sensitive   = true

  validation {
    condition = can(cidrhost(var.management_network, 1))
    error_message = "'management_network' must be a valid CIDR (e.g., 10.0.0.0/24)"
  }
}

// Backup credentials
variable "backblaze_bucket" {
  description = "Name of the Backblaze bucket."
  type        = string
  sensitive   = true
}

variable "backblaze_account_id" {
  description = "ID of the Backblaze account."
  type        = string
  sensitive   = true
}

variable "backblaze_account_key" {
  description = "Key (secret) for the Backblaze account."
  type        = string
  sensitive   = true
}

variable "healthcheck_url" {
  description = "Healthcheck URL to ping on backup success."
  type        = string
  sensitive   = true
}

variable "restic_password" {
  description = "Password for the Restic backup repo."
  type        = string
  sensitive   = true
}
