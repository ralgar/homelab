resource "openstack_dns_zone_v2" "homelab_internal" {
  name        = "homelab.internal."
  email       = "admin@homelab.internal"
  description = "An example zone"
  ttl         = 3000
  type        = "PRIMARY"
}

resource "openstack_dns_recordset_v2" "test" {
  zone_id     = openstack_dns_zone_v2.homelab_internal.id
  description = "A test record set"

  name        = "test.${openstack_dns_zone_v2.homelab_internal.name}"
  type        = "A"
  records     = ["192.168.1.100"]
  ttl         = 3000
}
