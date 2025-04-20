module "networks" {
  source = "./networks"

  environment = var.environment
}

module "flavors" {
  source = "./flavors"

  environment = var.environment
}

module "images" {
  source = "./images"

  environment = var.environment
}

module "magnum_templates" {
  source = "./magnum_templates"
  depends_on = [module.flavors, module.images]

  public_network = data.openstack_networking_network_v2.dmz2
}
