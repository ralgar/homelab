# Overview

By following the [GitOps](https://about.gitlab.com/topics/gitops) paradigm,
 this project is able to completely automate the deployment and operation of
 my OpenStack homelab. From bare metal to production can be done in an hour
 or two, following simple instructions.

The project is now permissively licensed - allowing you to use, modify, or
 redistribute it as desired, so long as you retain the original copyright
 notice. Check out the [code repository](https://gitlab.com/ralgar/homelab)
 for more info.

---

## Project Features

### OpenStack Host Management

- [x] Builds a self-installing Rocky Linux ISO.
- [x] Provides Ansible roles for deploying a single-node OpenStack cloud.
- [x] Provides a GitLab Runner for infrastructure CI/CD jobs.

### Production Server

- [x] Automated deployment through GitLab CI and Terraform.
- [x] Media server platform, with requests and automated acquisitions.
- [x] Home automation platform, easily integrated with the media platform.
- [x] Leverages Podman containers, and SELinux, for isolation.
- [x] Automatic OS and application container updates.
- [x] Automatic, incremental backups.

### Kubernetes Cluster (in development)

- [ ] Automated cluster provisioning through GitLab CI and Terraform.
- [x] Automated Continuous Deployment of applications through
      [Flux](https://fluxcd.io/flux).
- [x] Monitoring system based on Prometheus and Grafana.
- [x] Optional: Highly available control plane.
- [ ] Coming soon: Automatic snapshots and backups.
- [ ] Coming soon: Automatic horizontal scaling.
