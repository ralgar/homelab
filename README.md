# My Homelab

[![Latest Tag](https://img.shields.io/github/v/tag/ralgar/homelab?style=for-the-badge&logo=semver&logoColor=white)](https://github.com/ralgar/homelab/tags)
[![Pipeline Status](https://img.shields.io/gitlab/pipeline-status/ralgar/homelab?branch=feature%2Fk8s-rework&label=Pipeline&logo=gitlab&style=for-the-badge)](https://gitlab.com/ralgar/homelab/-/pipelines)
[![Code Coverage](https://img.shields.io/gitlab/coverage/ralgar/homelab/master?label=Coverage&logo=gitlab&style=for-the-badge)](https://gitlab.com/ralgar/homelab)
[![Software License](https://img.shields.io/badge/License-GPL--3.0-orange?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0.html)
[![GitLab Stars](https://img.shields.io/gitlab/stars/ralgar/homelab?color=gold&label=Stars&logo=gitlab&style=for-the-badge)](https://gitlab.com/ralgar/homelab)

## Overview

By following the [GitOps](https://about.gitlab.com/topics/gitops) paradigm, this
 project is able to automate the provisioning, deployment, and operation, of my
 sophisticated, virtualized/containerized homelab. It can serve as a framework
 for your homelab too.

### Features

- [x] **Proxmox Host Management**
  - [x] Basic Ansible role to batch upgrade Proxmox hosts
  - [ ] Rolling upgrades of Proxmox hosts (coming soon)
- [x] **Kubernetes Cluster**
  - [x] Fully-automated provisioning
  - [x] Easy horizontal and vertical scaling
  - [x] Optional, highly-available control plane
  - [x] Distributed object storage
  - [x] SELinux enabled
  - [x] Automatic upgrades (base OS and K3s distribution)
  - [x] Self-healing, [Continuous Deployment](https://about.gitlab.com/blog/2016/08/05/continuous-integration-delivery-and-deployment-with-gitlab)
  - [ ] Automated backups (coming soon)
- [x] **Applications and Services**
  - [x] Automated PKI
  - [x] LDAP server
  - [x] ~~GitLab and~~ a GitLab Runner for CI/CD jobs
  - [ ] Horizontally scalable Minecraft server (coming soon)
  - [ ] Home automation / media server (coming soon)

## Requirements

Dependencies:

- [Ansible](https://www.ansible.com/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [Kubernetes Python Client](https://github.com/kubernetes-client/python/)
- [Terraform](https://www.terraform.io/)

Other requirements:

- At least one [Proxmox VE](https://www.proxmox.com/) host

## Usage

### Initial Setup

1. Install the required dependencies.
1. Copy your SSH public key to the root account of the Proxmox host(s).

   ```sh
   ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<proxmox-host-ip>
   ```

1. Clone the repository and change directory into it.

   ```sh
   git clone https://gitlab.com/ralgar/homelab.git
   cd homelab
   ```

1. Create a copy of the `vars.template/` directory at `vars/`.

   ```sh
   cp -r vars.template vars
   ```

Now we are ready to start provisioning the infrastructure.

### Building the cluster

You can build the cluster infrastructure as follows:

1. Edit the variables in `vars/secret.yml` as needed.
1. Use the included `Makefile` to provision the infrastructure.

   ```sh
   # To build everything from scratch:
   make all

   # To build targets individually, in order:
   make template-rocky8
   make template-k3s-cluster
   make apply-infrastructure
   ```

### Deploying apps in the cluster

Apps are deployed to the cluster by use of the `cluster` directory.

1. Add or edit files in `cluster/<category>/<app-namespace>`.
1. Commit the changes in `git` and push them to your repository.

### Destroying the cluster

To completely destroy the cluster infrastructure:

```sh
make destroy-infrastructure
```

## License

Copyright: (c) 2022, Ryan Algar ([ralgar/homelab](https://gitlab.com/ralgar/homelab))

GNU General Public License v3.0 (see LICENSE or [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.txt)
