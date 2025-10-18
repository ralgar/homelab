terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.1"
    }
  }
}
