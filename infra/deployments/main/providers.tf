# Define required providers
terraform {
required_version = ">= 1.0"
  backend "http" {}
  required_providers {
    ignition = {
      source = "community-terraform-providers/ignition"
      version = "2.3.5"
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
  tenant_name         = var.environment == "prod" ? var.deployment : "${var.deployment}-${var.environment}"
}
