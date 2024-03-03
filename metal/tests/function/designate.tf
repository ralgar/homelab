resource "openstack_dns_zone_v2" "test_internal" {
  name        = "test.internal."
  email       = "admin@test.internal"
  description = "An example zone"
  ttl         = 3600
  type        = "PRIMARY"
}

resource "openstack_dns_recordset_v2" "test" {
  zone_id     = openstack_dns_zone_v2.test_internal.id
  description = "CirrOS Test VM"

  name        = "cirros.${openstack_dns_zone_v2.test_internal.name}"
  type        = "A"
  records     = [openstack_compute_instance_v2.cirros.access_ip_v4]
  ttl         = 3600
}
