variable "node_cidr_address" {
  type    = string
  default = "10.0.20.100/24"
}

variable "network_gateway" {
  type    = string
  default = "10.0.20.1"
}

variable "cluster_name" {
  type    = string
  default = "talos"
}

variable "install_disk" {
  type        = string
  description = "Root disk for the Talos node"
  default     = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_23020Q804222"
}

// GitOps
variable "bootstrap" {
  # WARNING: Setting to 'false' is DESTRUCTIVE on an existing cluster.
  description = "Toggle whether to bootstrap the cluster using GitOps"
  type        = bool
  default     = true
}

variable "gitops_repo" {
  description = "Full path of the Git repo. Ex. 'http://domain.tld/user/repo.git'"
  type        = string
  default     = "https://gitlab.com/ralgar/homelab.git"
}

variable "gitops_ref_name" {
  description = "Full Git reference name to sync from. Ex. 'refs/heads/main'"
  type        = string
  default     = "refs/heads/main"
}

variable "gitlab_project_access_token" {
  description = "A GitLab Project Access Token (with Maintainer role, plus 'api' and 'read_api' scopes)."
  type        = string
  sensitive   = true
}
