# Introduction

This project manages deployments using dynamic GitLab CI/CD pipelines, enabling
 automated provisioning of isolated environments. Through a flexible pipeline
 structure, it supports both short-lived development environments tied to
 specific merge requests, and stable, persistent production deployments.

This approach ensures safe, scalable testing and validation of infrastructure
 changes before they are promoted to production.

---

## Deployments

Deployments are defined under `infra/deployments/*`, and each one is managed
 as part of a dynamic child pipeline matrix. This approach scales easily —
 you can define as many deployments as needed with minimal overhead.

### Adding a New Deployment

To add a new deployment:

1. Create a new Terraform root module under `infra/deployments/`.

1. Add the new deployment to the CI deployment matrix.

    !!! note
        The name given here must correspond to the name of the root module.

    ```yaml title='.gitlab-ci.yml'
    # We define the deployments here.
    .deployment_matrix: &deployments
      - DEPLOYMENT: ['main', 'my-project']
    ```

1. Push your changes to a new branch and open a Merge Request. A new
   **ephemeral dev environment** will be provisioned for validation.

Once validated, merging the MR into `main` will promote the changes and
 trigger a production deployment (pending manual approval).

### Modifying an Existing Deployment

To update an existing deployment:

1. Make your changes under the relevant `infra/deployments/<name>/` directory.
1. Push your branch and open a Merge Request.
1. The pipeline will automatically prepare a dev environment for validation.

---

## Environments

### Production

Production deployments can be triggered in two ways:

- **Manual**: From the GitLab web UI by running a pipeline on the `main` branch.
- **Automated**: By merging a Merge Request into `main`.

This dual approach allows for streamlined continuous delivery, while still
 allowing deployments to be triggered manually for special cases.

These environments persist indefinitely, but can be manually destroyed at any
 time using the **Stop** button in the **Environments** tab in GitLab.

### Development

Ephemeral development environments are automatically initialized for each Merge
 Request. After the initial pipeline completes, a **manual deploy job** becomes
 available on the MR page.

Developers can use this to spin up a dev environment specific to their branch,
 making testing and validation easy and isolated.

!!! tip
    The `terraform:plan` job in merge request pipelines runs against the `main`
    branch, providing a *diff* of changes to be made when promoting to prod.

These environments can be manually destroyed via the **Stop** button on the
 MR page, or they will automatically self-destruct after 6 hours.
