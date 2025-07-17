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

variable "restic_password" {
  description = "Password for the Restic backup repo."
  type        = string
  sensitive   = true
}
