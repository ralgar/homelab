terraform {
required_version = ">= 1.0"
  required_providers {
    openstack = { source = "terraform-provider-openstack/openstack" }
    ignition  = { source = "community-terraform-providers/ignition" }
  }
}
