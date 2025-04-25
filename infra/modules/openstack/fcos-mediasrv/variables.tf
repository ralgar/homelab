variable "fcos_version" {
  description = "Desired major version of the instance image"
  type        = number
}
variable "keypair" {}
variable "network" {}
variable "data_volume" {}
variable "media_volume" {}

variable "environment" {
  type = string
}

variable "domain" {
  type = string
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
}
