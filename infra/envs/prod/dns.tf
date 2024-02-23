// We need to create records in the 'prod' project, as it owns the zone.
data "openstack_identity_project_v3" "prod" {
  name = "prod"
}

data "openstack_dns_zone_v2" "default" {
  project_id  = data.openstack_identity_project_v3.prod.id
  description = "Default zone"
}

resource "openstack_dns_recordset_v2" "environment_root" {
  project_id  = data.openstack_identity_project_v3.prod.id
  zone_id     = data.openstack_dns_zone_v2.default.id
  description = "Local environment root domain"

  name    = "${var.environment}.${data.openstack_dns_zone_v2.default.name}"
  type    = "A"
  records = [module.fcos.ipv4_address]
  ttl     = 3000
}

resource "openstack_dns_recordset_v2" "environment_wildcard" {
  project_id  = data.openstack_identity_project_v3.prod.id
  zone_id     = data.openstack_dns_zone_v2.default.id
  description = "Local environment wildcard subdomain"

  name        = "*.${openstack_dns_recordset_v2.environment_root.name}"
  type        = "CNAME"
  records     = [openstack_dns_recordset_v2.environment_root.name]
  ttl         = 3000
}
