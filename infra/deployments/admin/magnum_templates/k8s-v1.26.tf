resource "openstack_containerinfra_clustertemplate_v1" "k8s_1_26_8_1" {
  name                  = "Kubernetes v1.26.8-1"
  image                 = data.openstack_images_image_v2.fcos_41_latest.id
  coe                   = "kubernetes"
  dns_nameserver        = "1.1.1.1"
  docker_storage_driver = "overlay2"
  docker_volume_size    = 40
  volume_driver         = "cinder"
  network_driver        = "flannel"
  server_type           = "vm"
  external_network_id   = var.public_network.id

  labels = {
    # Node Options
    boot_volume_size = 10
    boot_volume_type = "PREMIUM"
    docker_volume_type = "PREMIUM"
    etcd_volume_size = 10
    etcd_volume_type = "PREMIUM"
    hw_cpu_mode = "host-passthrough"

    # Kubernetes Core Components
    kube_tag = "v1.26.8-rancher1"
    flannel_tag = "v0.15.1"  # Magnum pulls from outdated repo
    container_runtime = "containerd"
    containerd_version = "1.6.20"
    containerd_tarball_sha256 = "1d86b534c7bba51b78a7eeb1b67dd2ac6c0edeb01c034cc5f590d5ccd824b416"
    coredns_tag = "1.10.1"

    # OpenStack Cloud / CSI Components
    autoscaler_tag = "v1.26.4"
    cloud_provider_tag = "v1.26.4"
    cinder_csi_plugin_tag = "v1.26.4"
    k8s_keystone_auth_tag = "v1.26.4"
    magnum_auto_healer_tag = "v1.26.4"
    csi_attacher_tag = "v4.2.0"
    csi_provisioner_tag = "v3.4.1"
    csi_snapshotter_tag = "v6.2.1"
    csi_resizer_tag = "v1.7.0"
    csi_node_driver_registrar_tag = "v2.8.0"
    auto_healing_controller = "magnum-auto-healer"
    keystone_auth_enabled = true
    kube_dashboard_enabled = false
  }
}
