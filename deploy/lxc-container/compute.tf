resource "proxmox_lxc" "lxc-compute" {
  hostname     = var.hostname
  description  = <<-EOT
    ## ${var.title}
    ----

    ${var.description}

    **Type:** LXC Container <br>
    **Tags:** ${join(",", var.tags)}
  EOT

  target_node  = var.guestTargetNode
  ostemplate   = var.guestCtImage
  unprivileged = true
  start        = true
  onboot       = var.startOnBoot
  tags         = join(",", var.tags)

  // System Resources
  cores   = var.cores
  memory  = var.memory
  swap    = var.swap

  rootfs {
    storage = var.guestStoragePool
    size    = "${var.rootSize}G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${cidrhost(var.netPrefix, var.netHostNums[var.countIndex])}/${substr(var.netPrefix, -2, 2)}"
    gw     = var.netGateway
  }

  features {
    nesting = true
  }

  // LXC Init Config
  searchdomain    = var.netDomain
  nameserver      = "${var.netDnsHosts[0]} ${var.netDnsHosts[1]} ${var.netDnsHosts[2]}"
  ssh_public_keys = file(var.guestPubKeyFile)
}
