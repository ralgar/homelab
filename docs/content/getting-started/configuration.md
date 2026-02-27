# Configuration

Before we can start deploying we need to configure a few things.

!!! tip
    It is strongly recommended to use consistent identifiers to define
    your block devices, such as the WWN identifiers from `/dev/disk/by-id`
    or the PCI bus paths from `/dev/disk/by-path`.

---

## GitLab Configuration

### Creating the GitLab Runner Token

This step will create a GitLab Runner token, which will then be used to deploy
 a self-hosted runner on your Kubernetes cluster. This will be used to run
 CI/CD jobs for your homelab (and other projects if you wish).

!!! warning "Security Risk"
    Using a self-hosted runner can be dangerous. If a malicious actor were to
    open a Merge Request containing exploit code, they could potentially
    execute that code in your Kubernetes cluster. Be careful when approving
    CI jobs from untrusted users!

In your GitLab project, go to **Settings >> CI/CD** and expand the **Runners**
 section. Create a new Runner with the tag `homelab`, and make note of the
 **Runner Token** as you'll need to provide this to your cluster via a
 [GitLab CI/CD Variable](#setting-cicd-variables).

### Setting CI/CD variables

In your GitLab project, go to **Settings >> CI/CD**, and expand the
 **Variables** section.

!!! warning "Security Risk"
    Make sure you set the visibility of sensitive variables to *Masked* to
    prevent them from appearing in CI logs!

Create/set the following variables in GitLab CI.

| **Key**                  | **Description**                                      |
|--------------------------|------------------------------------------------------|
| `BACKUPS__ETCD_PUBKEY`   | Public key for encrypted etcd backups (via age tool) |
| `BACKUPS__REPO_PASSWORD` | Password for Restic and pgBackrest repos             |
| `BACKUPS__S3_ACCESS_KEY` | S3 access key for bucket access                      |
| `BACKUPS__S3_SECRET_KEY` | S3 secret key for bucket access                      |
| `CLOUDFLARE_API_TOKEN`   | Used by cert-manager for DNS-01 challenges           |
| `GITLAB_RUNNER_TOKEN`    | Used for registering the self-hosted runner          |
| `HEALTHCHECK_URL`        | Healthchecks.io endpoint for monitoring Prometheus   |
| `PUSHOVER_TOKEN`         | Pushover application token for Prometheus alerts     |
| `PUSHOVER_USER_KEY`      | Pushover account for Prometheus alerts               |

---

## Terraform Configuration

In the `metal/` module, you'll find the `variables.tf` file which defines the
 input variables for bootstrapping Talos Linux. You can override the default
 values by creating a `terraform.tfvars` file and defining your own values.

```hcl title="metal/terraform.tfvars"
# Required: Network address of the Talos node in CIDR notation
node_cidr_address = "10.0.20.100/24"

# Required: The network gateway
network_gateway = "10.0.20.1"

# Required: The disk you want to install Talos Linux to
install_disk = "/dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_23020Q804222"

# Required: Change this to your own repository
gitops_repo = "https://gitlab.com/ralgar/homelab.git"

# Optional: Set a custom branch or merge request
gitops_ref_name= "refs/heads/main"

# Required: You'll need to create a Project Access Token (PAT) in GitLab
# External-secrets will use this to access the CI/CD variables
gitlab_project_access_token = "my-gitlab-access-token"
```

---

## Manifest Configuration

You'll also need to make changes as required to the following manifests.

### System

- `kubernetes/workloads/system/rook-ceph/config/rook-ceph-config.yaml`
- `kubernetes/workloads/system/talos-backup/sync.yaml`
- `kubernetes/workloads/system/networking/manifests/*.yaml`

### Apps

- `kubernetes/workloads/apps/media-server/common/sync.yaml`
- `kubernetes/workloads/apps/media-server/jellyfin/sync.yaml`
- `kubernetes/workloads/apps/media-server/seerr/sync.yaml`
- `kubernetes/workloads/apps/smart-home/home-assistant/sync.yaml`
