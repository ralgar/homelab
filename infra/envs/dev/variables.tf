variable "openstack_clouds_file" {
  description = "Path to OpenStack authentication file (clouds.yaml)"
  type        = string
  default     = "../../../metal/output/clouds.yaml"
}

variable "gitops_repo" {
  description = "Full path of the Git repo. Ex. 'http://domain.tld/user/repo.git'"
  type        = string
  default     = "https://gitlab.com/ralgar/homelab.git"
}

variable "gitops_branch" {
  description = "The Git branch to sync from. Ex. 'main'"
  type        = string
  default     = "main"
}

variable "gitops_path" {
  description = "Git directory to sync from. Ex. './cluster/flux-sync'"
  type        = string
  default     = "./cluster/system/flux-sync"
}
