resource "proxmox_vm_qemu" "vm-compute" {
  name    = "k3s-controller-${var.countIndex}"
  desc        = <<-EOT
    ## K3s Controller #${var.countIndex}
    ---

    A K3s control-plane node.

    **Type:** QEMU Virtual Machine <br>
    **Tags:** k3s-cluster,k3s-controller
  EOT
  target_node = var.guestTargetNode

  tablet   = false
  oncreate = true
  onboot   = true
  clone    = "template-rocky8-k3s-master"
  os_type  = "cloud-init"
  agent    = 1
  tags     = "k3s-cluster,k3s-controller"

  // System Resources
  #pool    = "pool0"
  cores   = 2
  sockets = 1
  memory  = 2048

  disk {
    type    = "scsi"
    storage = var.guestStoragePool
    size    = "8G"
  }

  disk {
    type    = "scsi"
    storage = var.guestStoragePool
    size    = "16G"
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
