output "controlplane_ip" {
  value = local.controlplane_ip
}

output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubernetes_client_configuration
  sensitive = true
}

locals {
  controlplane_ip = var.enable_floating_ip ? openstack_networking_floatingip_v2.controlplane[0].address : openstack_compute_instance_v2.controlplane.access_ip_v4
  kubeconfig = yamldecode(talos_cluster_kubeconfig.this.kubeconfig_raw)

  kubeconfig_patched_raw = yamlencode(merge(local.kubeconfig, {
    clusters = [
      for c in local.kubeconfig.clusters : merge(c, {
        cluster = merge(c.cluster, {
          server = "https://${local.controlplane_ip}:6443"
        })
      })
    ]
  }))
}

output "kubeconfig_raw" {
  value     = local.kubeconfig_patched_raw
  sensitive = true
}
