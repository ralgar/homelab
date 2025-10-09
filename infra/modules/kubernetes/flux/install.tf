resource "helm_release" "flux_install" {
  repository       = "https://fluxcd-community.github.io/helm-charts"
  chart            = "flux2"
  version          = "2.17.0"
  name             = "flux2"
  namespace        = "flux-system"
  create_namespace = true
  atomic           = true

  values = [file("${path.module}/templates/install-values.yaml")]
}
