resource "openstack_dns_zone_v2" "environment" {
  name        = "${var.environment}.${var.domain}."
  email       = "placeholder@${var.domain}"
  description = "Environment-scoped internal zone (${var.environment})"
  ttl         = 3600
  type        = "PRIMARY"
}
