# Homelab Provisioning

## About the project
A set of Ansible/Terraform deployments, to automate the provisioning of my homelab services. Everything runs on a combination of Debian LXC containers, and RHEL 8 virtual machines.

Currently includes:
- Proxmox host management
- DNS nameservers
- PostgreSQL database
- Development container
- Minecraft server

Coming soon:
- PKI server
- LDAP server
- Media server

## Requirements
Dependencies:
- [Ansible](https://www.ansible.com/)
- [Terraform](https://www.terraform.io/)
- python-netaddr
- python-psycopg2

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
   $ git clone https://github.com/basschaser/homelab-provisioning.git
   $ cd homelab-provisioning
   ```
4. Copy the `vars.template` directory to `vars`.
   ```
   $ cp -r vars.template vars`
   ```
5. Edit the variables in `vars/global.yml` as needed.
6. Edit the parameters in `hosts.proxmox.yml` to point to a Proxmox host.
7. Initialize the Terraform deployment.
   ```
   $ cd ./deploy
   $ terraform init
   $ cd ../
   ```

Now we are ready to start deploying the infrastructure.

### Deploying the infrastructure
The base infrastructure runs in Debian LXC containers, and is required to properly configure the user-facing services. You can deploy the base infrastructure as follows:
1. **Optional:** Initialize the Proxmox host(s).
   * Run the `proxmox-init.yml` playbook
2. Deploy the base infrastructure services.
   * Run the `infrastructure.yml` playbook
3. Change your router and/or device settings to use the new DNS servers.

### Deploying the user-facing services
The user-facing services can be deployed modularly, in any desired combination.

1. Edit the variables in `vars/<service-name>.yml` as needed.
2. Run the `<service-name>.yml` playbook.

### Destroying services
To destroy any of the created services, simply append `-e state=absent` to the `ansible-playbook` command:
```
$ ansible-playbook nameservers.yml -e state=absent
```
