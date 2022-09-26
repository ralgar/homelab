# My Homelab

[![Latest Tag](https://img.shields.io/github/v/tag/ralgar/homelab?style=for-the-badge&logo=semver&logoColor=white)](https://github.com/ralgar/homelab/tags)
[![Pipeline Status](https://img.shields.io/gitlab/pipeline-status/ralgar/homelab?branch=feature%2Fk8s-rework&label=Pipeline&logo=gitlab&style=for-the-badge)](https://gitlab.com/ralgar/homelab/-/pipelines)
[![Software License](https://img.shields.io/badge/License-GPL--3.0-orange?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0.html)
[![GitLab Stars](https://img.shields.io/gitlab/stars/ralgar/homelab?color=gold&label=Stars&logo=gitlab&style=for-the-badge)](https://gitlab.com/ralgar/homelab)

## Overview

By following the [GitOps](https://about.gitlab.com/topics/gitops) paradigm, this
 project is able to automate the provisioning, deployment, and operation, of my
 sophisticated, virtualized/containerized homelab. It can serve as a framework
 for your homelab as well.

**Note:** While this project is fully-functional, I still consider it to be in
 the *alpha* stage of development. As such, you should expect breaking changes.

### Features

- [x] **Proxmox Host Management**
  - [x] Basic Ansible role to batch upgrade Proxmox hosts
  - [ ] Rolling upgrades of Proxmox hosts (coming soon)
- [x] **Kubernetes Cluster**
  - [x] Fully-automated provisioning
  - [x] Easy horizontal and vertical scaling
  - [x] Optional, highly-available control plane
  - [x] Backed by Ceph (distributed object storage)
  - [x] SELinux enforcing
  - [x] Automated upgrades (base OS and K3s distribution)
  - [x] [Continuously Deployed](https://about.gitlab.com/blog/2016/08/05/continuous-integration-delivery-and-deployment-with-gitlab), using the GitLab Kubernetes Agent
  - [x] Automated internal PKI
  - [x] Automated secret generation
  - [ ] Monitoring and alerts (coming soon)
  - [ ] Automatic snapshots and backups (coming soon)
- [x] **Applications and Services**
  - [x] LDAP server for [IdM](https://en.wikipedia.org/wiki/Identity_management)
  - [x] GitLab Runner for local CI jobs
  - [x] Media server and automated requests system
  - [ ] Home automation platform (coming soon)
  - [ ] Horizontally scalable Minecraft server (coming soon)

## Requirements

**Dependencies:**

- [Ansible](https://www.ansible.com/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [Kubernetes Python Client](https://github.com/kubernetes-client/python/)
- [Packer](https://www.packer.io/)
- [Terraform](https://www.terraform.io/)

**Other requirements:**

- A reasonable understanding of the technologies used in this project.
- At least one [Proxmox VE](https://www.proxmox.com/) host, with sufficient
  minimum system resources:

  | CPU       | Memory    | Storage  |
  |-----------|-----------|----------|
  | Quad Core | 32 GB RAM | 1 TB SSD |

## Usage

### Initial Setup

1. Install the required dependencies.
1. Set up Ceph disributed storage, with CephFS, on the Proxmox host(s).
1. Copy your SSH public key to the root account of the Proxmox host(s).

   ```sh
   ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<proxmox-host-ip>
   ```

1. Clone this repository and change directory into it.

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

1. Wait until the cluster has finished initial deployment.

   ```sh
   kubectl get pods -A
   ```

   All pods should be either ready and running, or completed.

1. Run the post-deployment bootstrap tasks.

   ```sh
   make post-bootstrap
   ```

**Notes:**

- Beware, the template building step will overwrite any kubeconfig you have
  stored at `~/.kube/config`. This will be fixed in a future revision.
- The post-deployment bootstrap requires elevated privileges to add the
  root CA certificate to your local certificate store.
- The post-deployment bootstrap doesn't always complete successfully. If it
  fails, simply run it again until it completes successfully.

### Deploying additional apps in the cluster

Apps are deployed to the cluster by use of the `cluster` directory.

1. Add or edit Kubernetes manifests in `cluster/<category>/<app-name>`.
1. Commit the changes in `git`, and push them to your repository.

### Destroying the cluster

To completely destroy the cluster infrastructure:

```sh
make destroy-infrastructure
```

## License

Copyright: (c) 2022, Ryan Algar ([ralgar/homelab](https://gitlab.com/ralgar/homelab))

GNU General Public License v3.0 (see LICENSE or [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.txt)
