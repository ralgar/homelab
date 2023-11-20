resource "kubernetes_config_map_v1" "flux_configs" {
  metadata {
    name      = "cluster-config-vars"
    namespace = "flux-system"
  }

  data = var.configs

  depends_on = [helm_release.flux_install]
}

resource "kubernetes_secret_v1" "flux_secrets" {
  metadata {
    name      = "cluster-secret-vars"
    namespace = "flux-system"
  }

  type = "Opaque"
  data = sensitive(var.secrets)

  depends_on = [helm_release.flux_install]
}

resource "helm_release" "flux_sync" {
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2-sync"
  version          = "1.4.0"
  name             = "flux-system"
  namespace        = "flux-system"
  create_namespace = true
  atomic           = true

  values = [templatefile("${path.module}/templates/sync-values.yaml", {
    repository = var.repository
    ref_name   = var.ref_name
    path       = var.path
  })]

  depends_on = [
    kubernetes_config_map_v1.flux_configs,
    kubernetes_secret_v1.flux_secrets,
  ]
}
