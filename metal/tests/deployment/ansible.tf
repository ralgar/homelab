resource "ansible_playbook" "deploy" {
  playbook   = "${path.root}/../../10-deploy-openstack.yml"
  name       = "openstack"
  replayable = true

  extra_vars = {
    ansible_host                 = openstack_compute_instance_v2.openstack.access_ip_v4
    ansible_ssh_user             = "rocky"
    ansible_ssh_private_key_file = local_sensitive_file.ssh_private_key.filename
    ansible_host_key_checking    = "false"
    ansible_stdout_callback      = "debug"

    ci_pipeline = "true"
  }
}

output "ansible_stdout" {
  value = ansible_playbook.deploy.ansible_playbook_stdout
}
