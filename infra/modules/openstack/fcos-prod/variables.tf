variable "image" {}
variable "keypair" {}
variable "network" {}
variable "data_volume" {}
variable "media_volume" {}

variable "restic_password" {
  description = "Password for the Restic backup repo."
  type        = string
}

variable "gdrive_oauth" {
  description = "OAuth credentials for Google Drive (see https://rclone.org/drive)."
  type = object({
    client_id = string
    client_secret = string
    token = string
    root_folder_id = string
  })
}