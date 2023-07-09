# Split multi-doc YAML with
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest
data "kubectl_file_documents" "sync_source" {
  content = templatefile("${path.module}/templates/sync.yaml", {
    repository = var.repository
    branch     = var.branch
    path       = var.path
  })
}

# Apply manifests
resource "kubectl_manifest" "sync_source" {
  for_each      = data.kubectl_file_documents.sync_source.manifests
  yaml_body     = each.value
  lifecycle { ignore_changes = [yaml_body, yaml_incluster] }
  depends_on    = [ kubectl_manifest.flux_install ]
}
