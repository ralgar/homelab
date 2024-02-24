resource "openstack_dns_zone_v2" "environment" {
  name        = "${var.environment}.${var.domain}."
  email       = "placeholder@${var.domain}"
  description = "Environment-scoped internal zone (${var.environment})"
  ttl         = 3600
  type        = "PRIMARY"
}

resource "openstack_dns_recordset_v2" "root" {
  zone_id     = openstack_dns_zone_v2.environment.id
  description = "Environment root record (${var.environment})"

  name    = openstack_dns_zone_v2.environment.name
  type    = "A"
  records = [module.fcos.ipv4_address]
  ttl     = 3600
}

resource "openstack_dns_recordset_v2" "wildcard" {
  zone_id     = openstack_dns_zone_v2.environment.id
  description = "Environment wildcard subdomain (${var.environment})"

  name    = "*.${openstack_dns_recordset_v2.root.name}"
  type    = "CNAME"
  records = [openstack_dns_recordset_v2.root.name]
  ttl     = 3600
}
