resource "local_sensitive_file" "kube_config" {
  filename = "${path.root}/../../../output/kube_config"
  content  = openstack_containerinfra_cluster_v1.cluster.kubeconfig.raw_config

  directory_permission = "0700"
  file_permission      = "0600"
}

output "kube_config" {
  value = openstack_containerinfra_cluster_v1.cluster.kubeconfig
}
