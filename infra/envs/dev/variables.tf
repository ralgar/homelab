variable "openstack_clouds_file" {
  description = "Path to OpenStack authentication file (clouds.yaml)"
  type        = string
  default     = "../../../metal/output/clouds.yaml"
}

variable "environment" {
  description = "Deployment environment (prod, staging, or dev)."
  type        = string
  default     = "dev"
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

variable "gitops_path" {
  description = "Git directory to sync from. Ex. './cluster/flux-sync'"
  type        = string
  default     = "./cluster/system/flux-sync"
}
