packer {
  required_plugins {
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1.1.2"
    }
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1.1.0"
    }
  }
}
