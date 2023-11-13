module "flux" {
  source     = "./modules/flux"
  count      = var.bootstrap.enabled ? 1 : 0

  repository = var.bootstrap.repository
  ref_name   = var.bootstrap.ref_name
  path       = var.bootstrap.path
  secrets    = var.bootstrap.secrets

  depends_on = [openstack_containerinfra_cluster_v1.cluster]
}
