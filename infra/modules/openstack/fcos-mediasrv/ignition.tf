module "base" {
  source  = "../../ignition/base"
  keypair = var.keypair
  domain  = var.domain
}

module "backups" {
  source      = "../../ignition/backups"
  environment = var.environment

  backblaze_account_id  = var.backblaze_account_id
  backblaze_account_key = var.backblaze_account_key
  backblaze_bucket      = var.backblaze_bucket
  restic_password       = var.restic_password
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
