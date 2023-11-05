terraform {
required_version = ">= 1.0"
  required_providers {
    openstack = { source  = "terraform-provider-openstack/openstack" }
    local     = { source  = "hashicorp/local" }
  }
}

provider "helm" {
  kubernetes {
    host                   = openstack_containerinfra_cluster_v1.cluster.kubeconfig.host
    client_certificate     = openstack_containerinfra_cluster_v1.cluster.kubeconfig.client_certificate
    client_key             = openstack_containerinfra_cluster_v1.cluster.kubeconfig.client_key
    cluster_ca_certificate = openstack_containerinfra_cluster_v1.cluster.kubeconfig.cluster_ca_certificate
  }
}
