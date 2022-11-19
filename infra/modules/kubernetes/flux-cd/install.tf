# Split multi-doc YAML with
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest
data "kubectl_file_documents" "flux_install" {
  content = file("${path.root}/../cluster/system/flux-cd/flux-install.yaml")
}

# Apply the namespace first, solving resource ordering issue
resource "kubectl_manifest" "flux_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  labels:
    app.kubernetes.io/instance: flux-system
    app.kubernetes.io/part-of: flux
    app.kubernetes.io/version: v0.36.0
    pod-security.kubernetes.io/warn: restricted
    pod-security.kubernetes.io/warn-version: latest
  name: flux-system
YAML
  apply_only = true
}

# Apply manifests
resource "kubectl_manifest" "flux_install" {
  for_each   = data.kubectl_file_documents.flux_install.manifests
  yaml_body  = each.value
  depends_on = [ kubectl_manifest.flux_namespace ]
}
