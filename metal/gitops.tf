data "talos_cluster_health" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes  = [split("/", var.node_cidr_address)[0]]
  endpoints            = [split("/", var.node_cidr_address)[0]]
}

module "cluster1_gitops" {
  source     = "./modules/flux"
  depends_on = [data.talos_cluster_health.this]
  count = var.bootstrap ? 1 : 0

  providers = {
    helm       = helm.cluster1
    kubernetes = kubernetes.cluster1
  }

  repository = var.gitops_repo
  ref_name   = var.gitops_ref_name
  path       = "./kubernetes/clusters/metal"

  configs = {}

  secrets = {
    GITLAB_TOKEN_EXTERNAL_SECRETS = var.gitlab_project_access_token
  }
}
