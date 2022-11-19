resource "proxmox_vm_qemu" "vm-compute" {
  name  = "k3s-worker-${var.guestNumber}"
  desc  = <<-EOT
    ## K3s Worker #${var.guestNumber}
    ---

    A K3s worker node.

    **Type:** QEMU Virtual Machine <br>
    **Tags:** k3s-cluster,k3s-worker
  EOT
  target_node = var.guestTargetNode

  full_clone = false
  tablet   = false
  oncreate = true
  onboot   = true
  clone    = "template-k3s-worker"
  os_type  = "cloud-init"
  agent    = 1
  tags     = "k3s-cluster,k3s-worker"

  // System Resources
  cores   = var.guestCores
  vcpus   = var.guestVCPUs
  memory  = var.guestMemory

  disk {
    type    = "scsi"
    storage = var.guestStoragePool
    size    = "128G"
  }

  /*disk {
    type    = "scsi"
    storage = var.guestStoragePool
    size    = "128G"
  }*/

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
  ipconfig0    = "ip=${var.guestIPAddr},gw=${var.netGateway}"
}
