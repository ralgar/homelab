resource "openstack_dns_zone_v2" "root" {
  count       = var.environment == "prod" ? 1 : 0
  project_id  = data.openstack_identity_project_v3.prod.id
  name        = "${var.domain}."
  email       = "placeholder@${var.domain}"
  description = "Root zone"
  ttl         = 3600
  type        = "PRIMARY"
}

data "openstack_dns_zone_v2" "root" {
  count      = var.environment == "prod" ? 0 : 1
  project_id = data.openstack_identity_project_v3.prod.id
  name       = "${var.domain}."
}

locals {
  environment_domain = var.environment == "prod" ? "${var.domain}." : "${var.environment}.${var.domain}."
  zone_id = var.environment == "prod" ? openstack_dns_zone_v2.root[0].id : data.openstack_dns_zone_v2.root[0].id
}

resource "openstack_dns_recordset_v2" "env" {
  project_id  = data.openstack_identity_project_v3.prod.id
  zone_id     = local.zone_id
  description = "Environment root record (${var.environment})"

  name    = local.environment_domain
  type    = "A"
  records = [module.media_server.ipv4_address]
  ttl     = 1
}

resource "openstack_dns_recordset_v2" "env_wildcard" {
  project_id  = data.openstack_identity_project_v3.prod.id
  zone_id     = local.zone_id
  description = "Environment wildcard subdomain (${var.environment})"

  name    = "*.${openstack_dns_recordset_v2.env.name}"
  type    = "CNAME"
  records = [openstack_dns_recordset_v2.env.name]
  ttl     = 1
}
