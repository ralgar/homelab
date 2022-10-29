data "local_sensitive_file" "kube_config" {
  filename   = "${path.root}/../output/kube_config"
  depends_on = [ proxmox_vm_qemu.vm-compute ]
}

locals {
  kube_config = sensitive(yamldecode(data.local_sensitive_file.kube_config.content))
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
