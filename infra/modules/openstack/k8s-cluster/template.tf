// Kubernetes Cluster template
// See https://docs.openstack.org/magnum/latest/user/index.html#kubernetes

resource "openstack_containerinfra_clustertemplate_v1" "default" {
  name                  = "Kubernetes v1.26.8"
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
    // Kubernetes Core Components
    kube_tag                      = "v1.26.8-rancher1"
    flannel_tag                   = "v0.15.1"   // Pulling from outdated repo
    container_runtime             = "containerd"
    containerd_version            = "1.6.20"
    containerd_tarball_sha256     = "1d86b534c7bba51b78a7eeb1b67dd2ac6c0edeb01c034cc5f590d5ccd824b416"
    coredns_tag                   = "1.10.1"

    // OpenStack Cloud / CSI Components
    cloud_provider_tag            = "v1.26.4"
    cinder_csi_plugin_tag         = "v1.26.4"
    k8s_keystone_auth_tag         = "v1.26.4"
    csi_attacher_tag              = "v4.2.0"
    csi_provisioner_tag           = "v3.4.1"
    csi_snapshotter_tag           = "v6.2.1"
    csi_resizer_tag               = "v1.7.0"
    csi_node_driver_registrar_tag = "v2.8.0"

    // API server LB (if enabled)
    master_lb_floating_ip_enabled = true
    master_lb_allowed_cidrs       = "0.0.0.0/0"  // comma delimited list

    kube_dashboard_enabled        = false
  }
}
