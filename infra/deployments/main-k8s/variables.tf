variable "openstack_clouds_file" {
  description = "Path to OpenStack authentication file (clouds.yaml)"
  type        = string
  default     = "../../../metal/output/clouds.yaml"
}

variable "domain" {
  description = "A public domain that you own (ex: mydomain.com)"
  type        = string
  default     = "cluster.internal"
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment (prod, staging, or dev)."
  type        = string
  default     = "main-k8s"
}

variable "gitlab_project" {
  description = "GitLab Project path with namespace (eg. 'myuser/mycloudlab')."
  type        = string
}

variable "gitlab_token" {
  description = "GitLab Personal Access Token (PAT) or CI Job Token (may have permission issues)."
  type        = string
  sensitive   = true
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

variable "backup_repo_password" {
  description = "Encryption password for PGSQL and Restic backups."
  type        = string
}
