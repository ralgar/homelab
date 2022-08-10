resource "proxmox_vm_qemu" "vm-compute" {
  name  = "k3s-controller-0"
  desc  = <<-EOT
    ## K3s Controller #0
    ---

    A K3s control-plane node.

    **Type:** QEMU Virtual Machine <br>
    **Tags:** k3s-cluster,k3s-controller
  EOT
  target_node = var.guestTargetNode

  full_clone = false
  tablet   = false
  oncreate = true
  onboot   = true
  clone    = "template-k3s-master"
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
    size    = "32G"
  }

  /*disk {
    type    = "scsi"
    storage = var.guestStoragePool
    size    = "16G"
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
  ipconfig0    = "ip=dhcp"

  provisioner "local-exec" {
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "false"
    }
    interpreter = [
      "ansible-playbook",
      "-i", "${self.default_ipv4_address},",
      "-e", "@../vars/global.yml"
    ]
    command = "ansible/get-kubeconfig.yml"
  }
}
