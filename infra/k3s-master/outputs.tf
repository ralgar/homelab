data "remote_file" "kube_config" {
  conn {
    host  = proxmox_vm_qemu.vm-compute.default_ipv4_address
    user  = "ansible"
    sudo  = true
    agent = true
  }

  path = "/etc/rancher/k3s/k3s.yaml"
}

locals {
  kube_config = sensitive(yamldecode(data.remote_file.kube_config.content))
}

data "template_file" "kube_config" {
  template = file("${path.module}/templates/kube_config.tpl")
  vars = {
    cluster_ca_certificate = local.kube_config.clusters[0].cluster.certificate-authority-data
    cluster_ipv4_address   = "${proxmox_vm_qemu.vm-compute.default_ipv4_address}"
    client_certificate     = local.kube_config.users[0].user.client-certificate-data
    client_key             = local.kube_config.users[0].user.client-key-data
  }
}

resource "local_sensitive_file" "kube_config" {
  filename = "${path.root}/../output/kube_config"
  content  = data.template_file.kube_config.rendered

  directory_permission = "0700"
  file_permission      = "0600"
}

output "ipv4_address" {
  value = proxmox_vm_qemu.vm-compute.default_ipv4_address
}

output "client_certificate" {
  value     = base64decode(local.kube_config.users[0].user.client-certificate-data)
  sensitive = true
}

output "client_key" {
  value     = base64decode(local.kube_config.users[0].user.client-key-data)
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
  sensitive = true
}
