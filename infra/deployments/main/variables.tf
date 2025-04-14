variable "openstack_clouds_file" {
  description = "Path to OpenStack authentication file (clouds.yaml)"
  type        = string
}

variable "domain" {
  description = "A public domain that you own (ex: mydomain.com)"
  type        = string
}

variable "deployment" {
  description = "Name of the deployment. Should correspond to the name of the current directory."
  type = string
}

variable "environment" {
  description = "Deployment environment (prod, staging, or dev)."
  type        = string
}

// Production Server Variables
variable "restic_password" {
  description = "Password for the Restic backup repo."
  type        = string
}

variable "gdrive_oauth" {
  description = "OAuth credentials for Google Drive (see https://rclone.org/drive)."
  // NOTE: All double quotes within the token JSON string must be escaped.
  type = object({
    client_id = string
    client_secret = string
    token = string
    root_folder_id = string
  })
}
