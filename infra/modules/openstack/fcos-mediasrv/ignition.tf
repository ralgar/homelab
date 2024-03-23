module "accounts" {
  source  = "./modules/accounts"
  keypair = var.keypair
}

module "config" {
  source      = "./modules/config"
  domain      = var.domain
}

module "services" {
  source      = "./modules/services"
  environment = var.environment
  domain      = var.domain
}

module "storage"  { source = "./modules/storage" }

module "backups" {
  source          = "./modules/backups"
  environment     = var.environment
  restic_password = var.restic_password
  gdrive_oauth    = var.gdrive_oauth
}

data "ignition_config" "final" {
  filesystems = module.storage.filesystems
  directories = module.services.directories
  files       = concat(
    module.backups.files,
    module.config.files
  )
  links       = module.config.links
  systemd     = concat(
    module.backups.systemd,
    module.storage.systemd,
    module.services.systemd
  )
  users       = module.accounts.users
}
