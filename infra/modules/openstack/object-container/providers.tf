# Define required providers
terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = { source  = "terraform-provider-openstack/openstack" }
  }
}
