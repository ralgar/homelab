build {
  sources = [
    "source.qemu.windows_2019_core",
    "source.qemu.windows_2019_desktop"
  ]

  provisioner "ansible" {
    playbook_file = "./playbooks/windows-server.yml"
    user          = "Admin"
    timeout       = "60m"
    extra_arguments = [
      "-e", "ansible_winrm_server_cert_validation=ignore",
      "-e", "ansible_connection=ssh",
      "-e", "ansible_shell_type=powershell",
      "-e", "ansible_ssh_pass=password"
    ]
  }

  # Append .qcow2 to the output image file name
  post-processor "shell-local" {
    command = "mv output-${source.name}/${source.name} output-${source.name}/${source.name}.qcow2"
  }
}
