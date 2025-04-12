# Features

---

## OpenStack Cloud Platform

### Automated Deployment

- [x] Builds a self-installing Rocky Linux ISO
- [x] Provides Ansible roles for deploying a single-node OpenStack cloud
- [x] Provides a GitLab Runner for infrastructure CI/CD jobs

### OpenStack Services

- [x] Nova (Compute)
- [x] Neutron (Networking)
- [x] Octavia (Load Balancing)
- [x] Designate (DNS)
- [x] Ceph Storage Cluster
    - [x] Cinder Volumes (Block Storage)
    - [x] Cinder Backups (Block Storage)
    - [x] Glance (Image Storage)
    - [x] Manila (Shared Filesystems)
    - [x] RADOS Gateway (Object Storage)
- [x] Heat (Stack Orchestration)
- [x] Magnum (Container Orchestration)

### Administrative Features

- [x] Automated building of cloud-ready Windows Server images
    - [x] Windows Server 2019 Datacenter (Core)
    - [x] Windows Server 2019 Datacenter (Desktop)

---

## Homelab Infrastructure

These are the actual workloads that we'll be deploying on our cloud.

### FCOS All-in-One Server (in production)

A single Fedora CoreOS server. Simple and reliable, and little-to-no maintenance.

- [x] Complete media server platform, with requests and automated acquisitions.
- [x] Home automation platform, easily integrated with the media platform.
- [x] Fully automated deployment through GitLab CI and Terraform.
- [x] CI-driven staging environment, so you can test changes before merging.
- [x] Leverages Podman containers, and SELinux, for isolation.
- [x] Automatic OS and application container updates.
- [x] Automatic, incremental backups.

### Kubernetes Cluster (in development/testing)

- [ ] Automated cluster provisioning through GitLab CI and Terraform.
- [x] Automated Continuous Deployment of applications through
      [Flux](https://fluxcd.io/flux).
- [x] Monitoring system based on Prometheus and Grafana.
- [x] Highly available control plane (optional).
- [x] Automatic snapshots and backups.
- [ ] Planned: Automatic horizontal scaling.
