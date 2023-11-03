resource "openstack_containerinfra_cluster_v1" "cluster" {
  name                = "Cluster"
  cluster_template_id = openstack_containerinfra_clustertemplate_v1.basic.id
  master_count        = var.ha_control_plane ? 3 : 1
  node_count          = var.base_worker_count
  keypair             = var.keypair.name
  floating_ip_enabled = var.ha_control_plane ? false : true

  labels = {
    hw_cpu_mode = "host-passthrough"
  }
  merge_labels = true
}
