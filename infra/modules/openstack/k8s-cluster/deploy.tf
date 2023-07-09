module "flux" {
  source = "./modules/flux"
  count  = var.bootstrap.enabled ? 1 : 0

  repository = var.bootstrap.repository
  branch     = var.bootstrap.branch
  path       = var.bootstrap.path
}
