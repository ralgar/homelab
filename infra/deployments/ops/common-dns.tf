# Environment-scoped DNS zone
resource "openstack_dns_zone_v2" "ops" {
  name        = "${var.environment}.ops.internal."
  email       = "placeholder@${var.domain}.ops.internal"
  description = "DNS zone for operations services (${var.environment})"
  ttl         = 1
  type        = "PRIMARY"
}
