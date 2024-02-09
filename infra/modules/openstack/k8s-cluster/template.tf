resource "openstack_containerinfra_clustertemplate_v1" "basic" {
  name                  = "Kubernetes Cluster"
  image                 = var.image.id
  coe                   = "kubernetes"
  flavor                = "m1.xlarge"
  master_flavor         = "m1.medium"
  dns_nameserver        = "1.1.1.1"
  volume_driver         = "cinder"
  network_driver        = "flannel"
  server_type           = "vm"
  master_lb_enabled     = var.ha_control_plane ? true : false
  floating_ip_enabled   = var.ha_control_plane ? false : true

  fixed_network       = var.internal_network.id
  fixed_subnet        = var.internal_subnet.id
  external_network_id = var.external_network.id

  labels = {
    // OpenStack Cloud / CSI Components
    // Manually defined because Kolla is shipping VERY outdated versions
    cloud_provider_tag            = "v1.23.4"
    cinder_csi_plugin_tag         = "v1.23.4"
    csi_attacher_tag              = "v3.3.0"
    csi_provisioner_tag           = "v3.0.0"
    csi_snapshotter_tag           = "v4.2.1"
    csi_resizer_tag               = "v1.3.0"
    csi_node_driver_registrar_tag = "v2.4.0"

    // API server LB (if enabled)
    master_lb_floating_ip_enabled = true
    master_lb_allowed_cidrs       = "0.0.0.0/0"  // comma delimited list

    kube_dashboard_enabled        = false
  }
}
