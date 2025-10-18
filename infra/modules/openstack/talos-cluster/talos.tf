resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${openstack_compute_instance_v2.controlplane.access_ip_v4}:6443"

  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://${openstack_compute_instance_v2.controlplane.access_ip_v4}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [openstack_compute_instance_v2.controlplane.access_ip_v4]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = var.enable_floating_ip ? openstack_networking_floatingip_v2.controlplane[0].address : openstack_compute_instance_v2.controlplane.access_ip_v4

  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = format("%s-controller", var.cluster_name)
      install_disk = var.install_disk
    }),
    file("${path.module}/files/kubelet-cert-rotation.yaml"),
    templatefile("${path.module}/templates/provider-id.yaml.tmpl", {
      INSTANCE_ID = openstack_compute_instance_v2.controlplane.id
      REGION      = openstack_compute_instance_v2.controlplane.region
    }),
    file("${path.module}/files/extra-manifests.yaml"),
    file("${path.module}/files/pod-security.yaml"),
    templatefile("${path.module}/templates/inline-manifests.yaml.tmpl", {
      OS_AUTH_URL                      = var.openstack_auth_url
      OS_APPLICATION_CREDENTIAL_ID     = openstack_identity_application_credential_v3.cloud_provider.id
      OS_APPLICATION_CREDENTIAL_SECRET = openstack_identity_application_credential_v3.cloud_provider.secret
      OS_CLOUD_PROVIDER_MANIFEST       = data.helm_template.openstack_cloud_provider.manifest
      OS_CINDER_CSI_MANIFEST           = data.helm_template.openstack_cinder_csi.manifest
    }),
    templatefile("${path.module}/templates/controlplane-scheduling.yaml.tmpl", {
      worker_count = var.worker_count
    })
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  count                       = var.worker_count
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  node                        = var.enable_floating_ip ? openstack_networking_floatingip_v2.worker[count.index].address : openstack_compute_instance_v2.worker[count.index].access_ip_v4

  config_patches = [
    templatefile("${path.module}/templates/install-disk-and-hostname.yaml.tmpl", {
      hostname     = format("%s-worker-%d", var.cluster_name, count.index)
      install_disk = var.install_disk
    }),
    file("${path.module}/files/kubelet-cert-rotation.yaml"),
    templatefile("${path.module}/templates/provider-id.yaml.tmpl", {
      INSTANCE_ID = openstack_compute_instance_v2.worker[count.index].id
      REGION      = openstack_compute_instance_v2.worker[count.index].region
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.enable_floating_ip ? openstack_networking_floatingip_v2.controlplane[0].address : openstack_compute_instance_v2.controlplane.access_ip_v4
}

resource "time_sleep" "wait_for_bootstrap" {
  depends_on      = [talos_machine_bootstrap.this]
  create_duration = "60s"
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [time_sleep.wait_for_bootstrap]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = var.enable_floating_ip ? openstack_networking_floatingip_v2.controlplane[0].address : openstack_compute_instance_v2.controlplane.access_ip_v4
}
