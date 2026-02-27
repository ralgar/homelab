resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${split("/", var.node_cidr_address)[0]}:6443"

  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [split("/", var.node_cidr_address)[0]]
  nodes                = [split("/", var.node_cidr_address)[0]]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = split("/", var.node_cidr_address)[0]

  config_patches = [
    file("${path.module}/files/controlplane-scheduling.yaml"),
    file("${path.module}/files/etcd-backup-rbac.yaml"),
    file("${path.module}/files/increase-max-pods.yaml"),
    file("${path.module}/files/kubelet-cert-rotation.yaml"),
    file("${path.module}/files/metrics.yaml"),
    file("${path.module}/files/pod-security.yaml"),
    templatefile("${path.module}/templates/hostname.yaml.tmpl", {
      hostname     = format("%s-aio", var.cluster_name)
    }),
    templatefile("${path.module}/templates/storage.yaml.tmpl", {
      install_disk = var.install_disk
    }),
    templatefile("${path.module}/templates/network.yaml.tmpl", {
      cidr_address = var.node_cidr_address
      gateway   = var.network_gateway
    }),
    templatefile("${path.module}/templates/inline-manifests.yaml.tmpl", {
      CILIUM_MANIFEST = data.helm_template.cilium.manifest
    }),
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node = split("/", var.node_cidr_address)[0]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node = split("/", var.node_cidr_address)[0]
}
