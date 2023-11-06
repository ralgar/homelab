resource "helm_release" "flux_install" {
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2"
  version          = "2.7.0"
  name             = "flux2"
  namespace        = "flux-system"
  create_namespace = true
  atomic           = true

  values = [file("${path.module}/templates/install-values.yaml")]
}

resource "helm_release" "flux_sync" {
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2-sync"
  version          = "1.4.0"
  name             = "flux-system"
  namespace        = "flux-system"
  create_namespace = true
  atomic           = true

  depends_on = [helm_release.flux_install]

  values = [templatefile("${path.module}/templates/sync-values.yaml", {
    repository = var.repository
    ref_name   = var.ref_name
    path       = var.path
  })]
}
