# Define required providers
terraform {
required_version = ">= 1.0"
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3.0"
    }
    local     = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
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
