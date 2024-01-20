resource "time_sleep" "wait_for_instance" {
  depends_on = [openstack_compute_instance_v2.openstack]

  create_duration = "30s"
}

resource "ansible_playbook" "deploy" {
  playbook   = "${path.root}/../10-deploy-openstack.yml"
  name       = "openstack"
  replayable = true

  extra_vars = {
    ansible_host              = openstack_compute_instance_v2.openstack.access_ip_v4
    ansible_ssh_user          = "rocky"
    private_key               = "~/.ssh/id_ed25519"
    ansible_host_key_checking = "false"

    ci_pipeline = "true"
  }

  # Enable for debugging
  ignore_playbook_failure = false

  depends_on = [time_sleep.wait_for_instance]
}

output "ansible_stdout" {
  value = ansible_playbook.deploy.ansible_playbook_stdout
}

output "ansible_stderr" {
  value = ansible_playbook.deploy.ansible_playbook_stderr
}
