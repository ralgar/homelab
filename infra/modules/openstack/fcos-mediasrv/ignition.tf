module "base" {
  source  = "../../ignition/base"
  keypair = var.keypair
  domain  = var.domain
  subnet  = data.openstack_networking_subnet_v2.default
}

module "backups" {
  source          = "../../ignition/backups"
  environment     = var.environment
  restic_password = var.restic_password
  gdrive_oauth    = var.gdrive_oauth
}

module "mediasrv" {
  source      = "../../ignition/mediasrv"
  environment = var.environment
  domain      = var.domain
}

data "ignition_config" "final" {
  merge {
    source = "data:text/plain;charset=utf-8;base64,${module.base.ignition_config}"
  }
  merge {
    source = "data:text/plain;charset=utf-8;base64,${module.backups.ignition_config}"
  }
  merge {
    source = "data:text/plain;charset=utf-8;base64,${module.mediasrv.ignition_config}"
  }
}
