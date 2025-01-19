source "qemu" "windows_2019_core" {
  iso_url      = var.win_server_2019_iso_file
  iso_checksum = "none"

  output_directory = "./output-${source.name}"

  // VM Settings
  vm_name   = source.name
  cpus      = 2
  memory    = 4096
  headless  = true
  disk_size = "32000M"
  format    = "qcow2"

  floppy_files = [
    "./answer_files/${trimprefix(source.name, "windows_")}/autounattend.xml",
    "./scripts/powershell/enable-ssh.ps1",
  ]

  qemuargs = [
    [
      "-drive",
      "file=output-${source.name}/${source.name},if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1"
    ],
    [
      "-drive",
      "file=${var.win_server_2019_iso_file},media=cdrom,index=2"
    ],
    [
      "-drive",
      "file=${var.virtio_iso_file},media=cdrom,index=3"
    ]
  ]

  ssh_username      = "Admin"
  ssh_password      = "password"
  ssh_timeout       = "20m"

  net_device        = "virtio-net"
  disk_interface    = "virtio"

  shutdown_command  = "Stop-Computer"
}
