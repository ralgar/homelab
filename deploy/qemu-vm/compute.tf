resource "proxmox_vm_qemu" "vm-compute" {
  name        = var.hostname
  desc        = <<-EOT
    ## ${var.title}
    ----

    ${var.description}

    **Type:** QEMU Virtual Machine <br>
    **Tags:** ${join(",", var.tags)}
  EOT
  target_node = var.guestTargetNode

  oncreate = true
  onboot   = var.startOnBoot
  clone    = var.guestVmTemplate
  os_type  = "cloud-init"
  agent    = var.enableQemuAgent
  tags     = join(",", var.tags)

  // System Resources
  #pool    = "pool0"
  cores   = var.cores
  sockets = var.sockets
  memory  = var.memory

  disk {
    type    = "scsi"
    storage = var.guestStoragePool
    size    = "${var.rootSize}G"
  }

  dynamic "disk" {
    for_each = var.auxDisk ? [1] : []
    content {
      type    = "scsi"
      storage = var.guestStoragePool
      size    = "${var.auxDiskSize}G"
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  // Cloud-init config
  ciuser       = "ansible"
  cipassword   = null
  searchdomain = var.netDomain
  nameserver   = "${var.netDnsHosts[0]} ${var.netDnsHosts[1]} ${var.netDnsHosts[2]}"
  sshkeys      = file(var.guestPubKeyFile)
  ipconfig0    = "ip=${cidrhost(var.netPrefix, var.netHostNums[var.countIndex])}/${substr(var.netPrefix, -2, 2)},gw=${var.netGateway}"
}
