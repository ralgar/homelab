locals {
  environment_domain = var.environment == "prod" ? "${var.domain}." : "${var.environment}.${var.domain}."
}

resource "openstack_dns_zone_v2" "root" {
  project_id  = data.openstack_identity_project_v3.prod.id
  name        = "${var.domain}."
  email       = "placeholder@${var.domain}"
  description = "Root zone"
  ttl         = 3600
  type        = "PRIMARY"
}

resource "openstack_dns_recordset_v2" "env" {
  project_id  = data.openstack_identity_project_v3.prod.id
  zone_id     = openstack_dns_zone_v2.root.id
  description = "Environment root record (${var.environment})"

  name    = local.environment_domain
  type    = "A"
  records = [module.fcos.ipv4_address]
  ttl     = 3600
}

resource "openstack_dns_recordset_v2" "env_wildcard" {
  project_id  = data.openstack_identity_project_v3.prod.id
  zone_id     = openstack_dns_zone_v2.root.id
  description = "Environment wildcard subdomain (${var.environment})"

  name    = "*.${openstack_dns_recordset_v2.env.name}"
  type    = "CNAME"
  records = [openstack_dns_recordset_v2.env.name]
  ttl     = 3600
}
