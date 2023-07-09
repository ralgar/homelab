resource "openstack_containerinfra_cluster_v1" "cluster" {
  name                = "Cluster"
  cluster_template_id = openstack_containerinfra_clustertemplate_v1.basic.id
  master_count        = 1
  node_count          = 2
  keypair             = var.keypair.name

  labels = {
    hw_cpu_mode = "host-passthrough"
  }
  merge_labels = true
}
