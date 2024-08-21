terraform {
  required_providers {
    gitlab     = { source = "gitlabhq/gitlab",      version = "17.3.0" }
    helm       = { source = "hashicorp/helm",       version = "2.11.0" }
    kubernetes = { source = "hashicorp/kubernetes", version = "2.23.0" }
  }
}
