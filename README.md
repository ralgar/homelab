# Homelab Provisioning

[![Latest Tag](https://img.shields.io/github/v/tag/ralgar/homelab-provisioning?style=for-the-badge&logo=semver&logoColor=white)](https://github.com/ralgar/homelab-provisioning/tags)
[![Software License](https://img.shields.io/github/license/ralgar/homelab-provisioning?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0.html)
[![Github Stars](https://img.shields.io/github/stars/ralgar/homelab-provisioning?style=for-the-badge&logo=github&logoColor=white&color=gold)](https://github.com/ralgar/homelab-provisioning)

## Overview

A set of Ansible/Terraform deployments to automate the provisioning of my homelab.
 The services run on a combination of Debian LXC containers, and Rocky Linux
 (RHEL) 8 virtual machines with rootless podman containers.

### Features

- [x] Basic Proxmox host management
- [x] Automated internal DNS
- [x] PostgreSQL database
- [x] Automated PKI system
- [x] LDAP server
- [x] GitLab and a GitLab Runner for CI/CD jobs
- [x] Kubernetes Cluster (using K3s)
- [x] Simple Minecraft server
- [ ] Automated backups (coming soon)
- [ ] Media server (coming soon)
- [ ] Improved Proxmox host management (coming soon)

## Requirements

Dependencies:

- [Ansible](https://www.ansible.com/)
- [Terraform](https://www.terraform.io/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [Kubernetes Python Client](https://github.com/kubernetes-client/python/)
- [dnspython](https://github.com/rthalley/dnspython/)
- [netaddr](https://github.com/netaddr/netaddr)
- [psycopg2](https://github.com/psycopg/psycopg2)

Other requirements:

- [Proxmox VE](https://www.proxmox.com/) host

## Usage

### Initial Setup

1. Install the required dependencies.
1. Copy your SSH public key to the root account of the Proxmox host(s).

   ```sh
   ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<proxmox-host-ip>
   ```

1. Clone this repository and change directory into it.

   ```sh
   git clone --recurse-submodules https://github.com/basschaser/homelab-provisioning.git
   cd homelab-provisioning
   ```

1. Copy the `vars.template` directory to `vars`.

   ```sh
   cp -r vars.template vars`
   ```

1. Edit the variables in `vars/global.yml` and `vars/hosts.proxmox.yml` as needed.
1. Initialize the Terraform deployment.

   ```sh
   cd deploy
   terraform init
   cd ..
   ```

Now we are ready to start deploying the infrastructure.

### Deploying the infrastructure

The base infrastructure is required to properly configure the user-facing services.

You can deploy the base infrastructure as follows:

1. **Optional:** Initialize the Proxmox host(s).
  - Run the `proxmox-host.yml` playbook
1. Deploy the base infrastructure services.
  - Run the `10-nameservers.yml` playbook
  - Run the `20-infrastructure.yml` playbook
1. Change your router and/or device settings to use the new domain and DNS servers.

### Deploying the user-facing services

The user-facing services can be deployed modularly, in any desired combination.

1. Edit the variables in `vars/<service-name>.yml` as needed.
1. Run the `<service-name>.yml` playbook.

### Destroying services

To destroy the infrastructure:

```sh
make destroy-infrastructure
```

## License

Copyright: (c) 2022, Ryan Algar [ralgar/homelab](https://github.com/ralgar/homelab)

GNU General Public License v3.0 (see LICENSE or [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.txt)
