# Split multi-doc YAML with
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest
data "kubectl_file_documents" "sync_source" {
  content = file("${path.root}/../cluster/system/flux-cd/init-sync.yaml")
}

# Apply manifests
resource "kubectl_manifest" "sync_source" {
  for_each   = data.kubectl_file_documents.sync_source.manifests
  yaml_body  = each.value
  depends_on = [ kubectl_manifest.flux_install ]
}
