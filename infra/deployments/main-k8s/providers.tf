# Define required providers
terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
    }
    gitlab    = {
      source = "gitlabhq/gitlab"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "3.3.2"
    }
  }
}

locals {
  openstack_yaml = yamldecode(file(var.openstack_clouds_file))
  openstack_auth = sensitive(local.openstack_yaml.clouds.kolla-admin.auth)
}

# Configure the OpenStack Provider
provider "openstack" {
  auth_url            = sensitive(local.openstack_auth.auth_url)
  project_domain_name = sensitive(local.openstack_auth.project_domain_name)
  user_domain_name    = sensitive(local.openstack_auth.user_domain_name)
  user_name           = sensitive(local.openstack_auth.username)
  password            = sensitive(local.openstack_auth.password)
  tenant_name         = var.environment
}

# Configure the GitLab Provider
provider "gitlab" {
  token = var.gitlab_token
}

provider "google" {
  project = "k8s-backups"
  region  = "us-west1"
  zone    = "us-west1-a"
}

provider "helm" {
  alias = "cluster1"

  kubernetes {
    host                   = openstack_containerinfra_cluster_v1.cluster1.kubeconfig.host
    client_certificate     = openstack_containerinfra_cluster_v1.cluster1.kubeconfig.client_certificate
    client_key             = openstack_containerinfra_cluster_v1.cluster1.kubeconfig.client_key
    cluster_ca_certificate = openstack_containerinfra_cluster_v1.cluster1.kubeconfig.cluster_ca_certificate
  }
}

provider "kubernetes" {
  alias = "cluster1"

  host                   = openstack_containerinfra_cluster_v1.cluster1.kubeconfig.host
  client_certificate     = openstack_containerinfra_cluster_v1.cluster1.kubeconfig.client_certificate
  client_key             = openstack_containerinfra_cluster_v1.cluster1.kubeconfig.client_key
  cluster_ca_certificate = openstack_containerinfra_cluster_v1.cluster1.kubeconfig.cluster_ca_certificate
}
