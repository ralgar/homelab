# Define required providers
terraform {
  required_version = ">= 1.0"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
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
  openstack_yaml = yamldecode(file("${path.root}/../../../metal/output/clouds.yaml"))
  openstack_auth = sensitive(local.openstack_yaml.clouds.kolla-admin.auth)
}

# Configure the OpenStack Provider
provider "openstack" {
  auth_url            = sensitive(local.openstack_auth.auth_url)
  project_domain_name = sensitive(local.openstack_auth.project_domain_name)
  user_domain_name    = sensitive(local.openstack_auth.user_domain_name)
  user_name           = sensitive(local.openstack_auth.username)
  password            = sensitive(local.openstack_auth.password)
  tenant_name         = "dev"
}

provider "kubectl" {
  host                   = module.k8s_cluster.kube_config.host
  client_certificate     = module.k8s_cluster.kube_config.client_certificate
  client_key             = module.k8s_cluster.kube_config.client_key
  cluster_ca_certificate = module.k8s_cluster.kube_config.cluster_ca_certificate
  load_config_file       = false
}
