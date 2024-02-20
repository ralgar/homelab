resource "openstack_dns_zone_v2" "local" {
  name        = "${var.root_domain}."
  email       = "admin@${var.root_domain}"
  description = "Local zone"
  ttl         = 3000
  type        = "PRIMARY"
}

resource "openstack_dns_recordset_v2" "root" {
  zone_id     = openstack_dns_zone_v2.local.id
  description = "Local root record"

  name        = openstack_dns_zone_v2.local.name
  type        = "A"
  records     = [module.fcos.ipv4_address]
  ttl         = 3000
}

resource "openstack_dns_recordset_v2" "wildcard" {
  zone_id     = openstack_dns_zone_v2.local.id
  description = "Local wildcard record"

  name        = "*.${openstack_dns_recordset_v2.root.name}"
  type        = "CNAME"
  records     = [openstack_dns_recordset_v2.root.name]
  ttl         = 3000
}
