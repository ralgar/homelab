module "base" {
  source  = "../../ignition/base"
  keypair = var.keypair
  domain  = var.domain
}

data "ignition_config" "final" {
  merge {
    source = "data:text/plain;charset=utf-8;base64,${module.base.ignition_config}"
  }

  dynamic "merge" {
    for_each = var.ignition_configs
    content {
      source = "data:text/plain;charset=utf-8;base64,${merge.value}"
    }
  }
}
