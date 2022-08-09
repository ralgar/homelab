resource "proxmox_vm_qemu" "vm-compute" {
  name    = "k3s-worker-${var.countIndex}"
  desc        = <<-EOT
    ## K3s Worker #${var.countIndex}
    ---

    A K3s worker node.

    **Type:** QEMU Virtual Machine <br>
    **Tags:** k3s-cluster,k3s-worker
  EOT
  target_node = var.guestTargetNode

  tablet   = false
  oncreate = true
  onboot   = true
  clone    = "template-k3s-worker"
  os_type  = "cloud-init"
  agent    = 1
  tags     = "k3s-cluster,k3s-worker"

  // System Resources
  #pool    = "pool0"
  cores   = 4
  sockets = 1
  memory  = 8192

  disk {
    type    = "scsi"
    storage = var.guestStoragePool
    size    = "8G"
  }

  disk {
    type    = "scsi"
    storage = var.guestStoragePool
    size    = "128G"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  // Cloud-init config
  ciuser       = "ansible"
  cipassword   = null
  searchdomain = var.netDomain
  nameserver   = join(" ", var.netDnsHosts)
  sshkeys      = file(var.guestPubKeyFile)
  ipconfig0    = "ip=dhcp"
}
