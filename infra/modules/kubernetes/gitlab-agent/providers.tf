terraform {
  required_providers {
    gitlab     = { source = "gitlabhq/gitlab",      version = "17.3.0" }
    helm       = { source = "hashicorp/helm",       version = ">=3.0.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = ">=2.0.0" }
  }
}
