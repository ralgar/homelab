# My Homelab

[![Latest Tag](https://img.shields.io/gitlab/v/tag/ralgar/homelab?style=for-the-badge&logo=semver&logoColor=white)](https://gitlab.com/ralgar/homelab/tags)
[![Pipeline Status](https://img.shields.io/gitlab/pipeline-status/ralgar/homelab?branch=master&label=Pipeline&logo=gitlab&style=for-the-badge)](https://gitlab.com/ralgar/homelab/-/pipelines?page=1&scope=all&ref=master)
[![Software License](https://img.shields.io/badge/License-GPL--3.0-orange?style=for-the-badge&logo=gnu&logoColor=white)](https://www.gnu.org/licenses/gpl-3.0.html)
[![GitLab Stars](https://img.shields.io/gitlab/stars/ralgar/homelab?color=gold&label=Stars&logo=gitlab&style=for-the-badge)](https://gitlab.com/ralgar/homelab)

## Overview

By following the [GitOps](https://about.gitlab.com/topics/gitops) paradigm, this
 project is able to automate the provisioning, deployment, and operation, of my
 sophisticated, virtualized/containerized homelab. It can serve as a framework
 for your homelab as well.

**Note:** While this project is functional as-is, it is currently still in
 the *alpha* stage of development. As such, you should expect some minor
 issues, as well as breaking changes in future revisions.

### Features

- [x] **Proxmox Host Management**
  - [x] Basic Ansible role to batch upgrade Proxmox hosts
  - [ ] Rolling upgrades of Proxmox hosts (coming soon)
- [x] **Kubernetes Cluster**
  - [x] Fully-automated provisioning
  - [x] Easy horizontal and vertical scaling
  - [x] Optional, highly-available control plane
  - [x] Backed by Ceph (distributed object storage)
  - [x] Mandatory Access Control, enforced by [SELinux](https://www.redhat.com/en/topics/linux/what-is-selinux)
  - [x] Automated upgrades (base OS and K3s distribution)
  - [x] Continuously Deployed, using [Argo CD](https://argoproj.github.io/cd/)
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

## Prerequisites

##### Dependencies

- [Ansible](https://www.ansible.com/)
- [Helm](https://helm.sh/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [Kubernetes Python Client](https://github.com/kubernetes-client/python/)
- [Packer](https://www.packer.io/)
- [Terraform](https://www.terraform.io/)

##### Other requirements

- A reasonable understanding of the technologies used in this project.
- At least one [Proxmox VE](https://www.proxmox.com/en/proxmox-ve) host,
  with sufficient minimum system specifications:

  | CPU       | Memory    | Storage  | Network      |
  |-----------|-----------|----------|--------------|
  | Quad Core | 32 GB RAM | 1 TB SSD | 1 GbE LAN    |

## Usage

Please read these instructions in their entirety before continuing,
 *especially* the [Notes and Issues](#notes-and-issues) section below.

### Initial Setup

1. Install the required [dependencies](#dependencies) on your local system.
1. Set up Ceph distributed storage, with CephFS, on the Proxmox host(s).
1. Copy your SSH public key to the root account of the Proxmox host(s).

   ```sh
   ssh-copy-id -i ~/.ssh/id_ed25519.pub root@<proxmox-host-ip>
   ```

1. Clone this repository with SSH, and change directory into it.

   ```sh
   git clone https://gitlab.com/ralgar/homelab.git
   cd homelab
   ```

1. Create a copy of the `vars.template/` directory at `vars/`.

   ```sh
   cp -r vars.template vars
   ```

1. Edit the variables in `vars/secret.yml` as needed.

Now we are ready to start provisioning the infrastructure.

### Building the cluster

You can build the cluster infrastructure as follows:

1. Use the included `Makefile` to provision the infrastructure.

   ```sh
   # To build everything in one shot:
   make all

   # To build targets individually, in order:
   make template-rocky8
   make template-k3s-cluster
   make apply-infrastructure
   ```

1. Wait until the cluster has finished initial deployment (approximately 5 minutes).

   ```sh
   KUBECONFIG=output/kube_config kubectl get pods -A
   ```

   All pods should be either ready and running, or completed.

1. Run the post-deployment bootstrap tasks.

   ```sh
   make post-bootstrap
   ```

##### Notes and Issues

- The post-deployment bootstrap requires elevated privileges to import the
  root CA certificate into your local certificate store. If you wish to audit
  the relevant Ansible role, it is located at `post-deploy/roles/ca_trust`.
- The post-deployment bootstrap doesn't always complete successfully. If it
  fails, simply run it again until it succeeds.

### Making changes to the cluster

In order to make your own changes to the cluster, you will need to fork
 this repository, alter the Argo CD configuration to point to your new
 GitOps repository, and re-deploy the cluster. Once this is done, you
 can commit changes to your repository, and ArgoCD will automatically
 apply them to the cluster.

Apps are deployed to the cluster by use of the `cluster` directory.

1. Add or edit Kubernetes manifests, or Helm charts, in
   `cluster/<category>/<app-name>`.
1. Commit the changes in `git`, and push them to your repository.

### Destroying the cluster

To completely destroy the cluster infrastructure:

```sh
make destroy-infrastructure
```

## License

Copyright: (c) 2022, Ryan Algar ([ralgar/homelab](https://gitlab.com/ralgar/homelab))

GNU General Public License v3.0 (see LICENSE or [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.txt))
