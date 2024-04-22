# Define required providers
terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.52.1"
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

provider "google" {
  project = "k8s-backups"
  region  = "us-west1"
  zone    = "us-west1-a"
}

provider "helm" {
  kubernetes {
    host                   = module.k8s_cluster.kube_config.host
    client_certificate     = module.k8s_cluster.kube_config.client_certificate
    client_key             = module.k8s_cluster.kube_config.client_key
    cluster_ca_certificate = module.k8s_cluster.kube_config.cluster_ca_certificate
  }
}

provider "kubernetes" {
  host                   = module.k8s_cluster.kube_config.host
  client_certificate     = module.k8s_cluster.kube_config.client_certificate
  client_key             = module.k8s_cluster.kube_config.client_key
  cluster_ca_certificate = module.k8s_cluster.kube_config.cluster_ca_certificate
}
