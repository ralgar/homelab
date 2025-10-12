variable "environment" {
  type = string
}

variable "fqdn" {
  description = "Fully-Qualified Domain Name. Used in the backup path and hostname."
  type        = string
}

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
}
