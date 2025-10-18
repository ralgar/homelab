resource "openstack_identity_application_credential_v3" "cloud_provider" {
  name        = "${var.cluster_name}-cloud-provider"
  description = "App credential for Kubernetes OpenStack Cloud Controller"
  roles       = ["admin"]
}

data "helm_template" "openstack_cloud_provider" {
  name             = "openstack-cloud-controller-manager"
  repository       = "https://kubernetes.github.io/cloud-provider-openstack"
  chart            = "openstack-cloud-controller-manager"
  namespace        = "kube-system"
  version          = "2.33.0"
  create_namespace = false
  atomic           = true

  set = [
    {
      name  = "cloudConfig.networking.internal-network-name"
      value = var.internal_network.name
    },
    {
      name  = "cloudConfig.networking.public-network-name"
      value = var.public_network.name
    },
    {
      name  = "cloudConfig.loadBalancer.floating-network-id"
      value = var.public_network.id
    },
    {
      name  = "cloudConfig.loadBalancer.create-monitor"
      value = true
    }
  ]

  set_sensitive = [
    {
      name  = "cloudConfig.global.auth-url"
      value = var.openstack_auth_url
    },
    {
      name  = "cloudConfig.global.application-credential-id"
      value = openstack_identity_application_credential_v3.cloud_provider.id
    },
    {
      name  = "cloudConfig.global.application-credential-secret"
      value = openstack_identity_application_credential_v3.cloud_provider.secret
    }
  ]
}

resource "local_file" "occm_yaml" {
  content  = join("\n---\n", values(data.helm_template.openstack_cloud_provider.manifests))
  filename = "${path.root}/../../../output/openstack-cloud-controller-manager.yaml"
}

data "helm_template" "openstack_cinder_csi" {
  name             = "openstack-cinder-csi"
  repository       = "https://kubernetes.github.io/cloud-provider-openstack"
  chart            = "openstack-cinder-csi"
  namespace        = "kube-system"
  version          = "2.33.1"
  create_namespace = false
  atomic           = true

  values = [
    file("${path.module}/files/cinder-csi-values.yaml")
  ]
}
