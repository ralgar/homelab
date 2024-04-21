resource "openstack_dns_recordset_v2" "root" {
  zone_id     = var.dns_zone.id
  description = "Environment root record (${var.environment})"

  name    = var.dns_zone.name
  type    = "A"
  records = [openstack_compute_instance_v2.fcos.access_ip_v4]
  ttl     = 3600
}

resource "openstack_dns_recordset_v2" "wildcard" {
  zone_id     = var.dns_zone.id
  description = "Environment wildcard subdomain (${var.environment})"

  name    = "*.${openstack_dns_recordset_v2.root.name}"
  type    = "CNAME"
  records = [openstack_dns_recordset_v2.root.name]
  ttl     = 3600
}
