# Homelab Provisioning
[![Latest Tag](https://img.shields.io/github/v/tag/ralgar/homelab-provisioning?style=for-the-badge&logo=semver&logoColor=white)](https://github.com/ralgar/homelab-provisioning/tags)
[![Software License](https://img.shields.io/github/license/ralgar/homelab-provisioning?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0.html)
[![Github Stars](https://img.shields.io/github/stars/ralgar/homelab-provisioning?style=for-the-badge&logo=github&logoColor=white&color=gold)](https://github.com/ralgar/homelab-provisioning)


## Overview
A set of Ansible/Terraform deployments to automate the provisioning of my homelab services. The services run on a combination of Debian LXC containers, and Rocky Linux (RHEL) 8 virtual machines with rootless podman containers.

### Features
- [x] Basic Proxmox host management
- [x] Automated internal DNS
- [x] PostgreSQL database
- [x] Basic development container
- [x] Simple Minecraft server
- [x] Automated PKI system
- [ ] LDAP server (coming soon)
- [ ] CI/CD pipeline (coming soon)
- [ ] Media server (coming soon)
- [ ] Improved Proxmox host management (coming soon)


## Requirements
Dependencies:
- [Ansible](https://www.ansible.com/)
- [Terraform](https://www.terraform.io/)
- [dnspython](https://github.com/rthalley/dnspython/)
- [netaddr](https://github.com/netaddr/netaddr)
- [psycopg2](https://github.com/psycopg/psycopg2)

Other requirements:
- [Proxmox VE](https://www.proxmox.com/) host


## Usage

### Initial Setup
1. Install the required dependencies.
2. Copy your SSH public key to the root account of the Proxmox host(s).
   ```
   $ ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<proxmox-host-ip>
   ```
3. Clone this repository and change directory into it.
   ```
   $ git clone --recurse-submodules https://github.com/basschaser/homelab-provisioning.git
   $ cd homelab-provisioning
   ```
4. Copy the `vars.template` directory to `vars`.
   ```
   $ cp -r vars.template vars`
   ```
5. Edit the variables in `vars/global.yml` and `vars/hosts.proxmox.yml` as needed.
6. Initialize the Terraform deployment.
   ```
   $ cd deploy
   $ terraform init
   $ cd ..
   ```

Now we are ready to start deploying the infrastructure.

### Deploying the infrastructure
The base infrastructure runs in Debian LXC containers, and is required to properly configure the user-facing services. You can deploy the base infrastructure as follows:
1. **Optional:** Initialize the Proxmox host(s).
   * Run the `proxmox-host.yml` playbook
2. Deploy the base infrastructure services.
   * Run the `10-nameservers.yml` playbook
   * Run the `20-infrastructure.yml` playbook
3. Change your router and/or device settings to use the new domain and DNS servers.

### Deploying the user-facing services
The user-facing services can be deployed modularly, in any desired combination.

1. Edit the variables in `vars/<service-name>.yml` as needed.
2. Run the `<service-name>.yml` playbook.

### Destroying services
To destroy any of the created services, simply append `-e state=absent` to the `ansible-playbook` command:
```
$ ansible-playbook minecraft.yml -e state=absent
$ ansible-playbook 20-infrastructure.yml -e state=absent
```


<!-- License -->
## License

Copyright: (c) 2022, Ryan Algar (https://github.com/ralgar/homelab-provisioning)

GNU General Public License v3.0 (see LICENSE or https://www.gnu.org/licenses/gpl-3.0.txt)
