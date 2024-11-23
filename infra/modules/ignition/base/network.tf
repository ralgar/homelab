data "ignition_kernel_arguments" "network_config" {
  shouldexist = ["ip=${cidrhost(var.subnet.cidr, 2)}::${var.subnet.gateway_ip}:${cidrnetmask(var.subnet.cidr)}:myhostname:ens3:none:1.1.1.1"]
}

data "ignition_file" "network_config" {
  path = "/etc/NetworkManager/system-connections/ens3.nmconnection"
  content {
    content = templatefile("${path.module}/templates/ens3.nmconnection", {
      cidr_address = join("/", [cidrhost(var.subnet.cidr, 2), split("/", var.subnet.cidr)[1]])
      gateway      = var.subnet.gateway_ip
      hostname     = var.domain
      dns_servers  = join(";", var.subnet.dns_nameservers)
    })
  }
}
