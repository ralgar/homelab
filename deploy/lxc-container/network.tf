// DNS A Records (Forward Zone)
resource "dns_a_record_set" "lxc-dns-a-record" {
  zone = "${var.netDomain}."
  name = var.hostname
  addresses = [
    "${cidrhost(var.netPrefix, var.netHostNums[var.countIndex])}"
  ]
  ttl = 3600
  count = var.addToDns ? 1 : 0
}

// DNS CNAME Records (Forward Zone)
resource "dns_cname_record" "lxc-dns-cname-record" {
  zone  = "${var.netDomain}."
  name  = "*.${var.hostname}"
  cname = "${var.hostname}.${var.netDomain}."
  ttl   = 3600
  count = var.dnsWildcard ? 1 : 0
}

// DNS Pointer Records (Reverse Zone)
resource "dns_ptr_record" "lxc-dns-ptr-record" {
  zone = "${join(".", reverse(slice(split(".", var.netPrefix), 0, 3)))}.in-addr.arpa."
  name = var.netHostNums[var.countIndex]
  ptr  = "${var.hostname}.${var.netDomain}."
  ttl  = 3600
  count = var.addToDns ? 1 : 0
}
