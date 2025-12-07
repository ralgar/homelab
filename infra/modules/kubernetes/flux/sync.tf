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

// This prevents `helm_resource.flux_install` from hanging on destroy.
// Flux needs time to destroy synced resources before it can uninstall itself.
resource "time_sleep" "delay_destroy" {
  depends_on = [helm_release.flux_install]
  destroy_duration = "60s"
}

resource "helm_release" "flux_sync" {
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2-sync"
  version          = "1.14.1"
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
    time_sleep.delay_destroy,
  ]
}
