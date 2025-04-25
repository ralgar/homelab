# CI/CD Configuration

Before we can start deploying we need to configure the CI/CD.

---

## Setting CI/CD variables

In your GitLab project, go to **Settings >> CI/CD**, and expand the
 **Variables** section.

!!! tip "Tip (Optional)"
    You can scope variables to a specific deployment or deployment
    environment by setting a wildcard like `main-*`, or a full environment
    name like `main-prod`, for the **Environment** parameter.

!!! warning "Security Risk"
    Make sure you set the visibility of sensitive variables to *Masked*,
    othewise they could appear in the CI logs!

### OpenStack Credentials

The most important value to set is the OpenStack credentials file, which will
 allow your CI pipelines to authenticate and manage resources in your
 OpenStack cloud.

- Create a **variable file** named `OS_CLOUDS`, with the contents of your
  `metal/output/clouds.yaml` file that was generated when deploying
  OpenStack.

---

## Deploying the GitLab Runner

This step will deploy a local GitLab Runner, in a Docker container, directly
 on the OpenStack host. This will be used to run CI/CD jobs within your
 OpenStack environment.

!!! warning "Security Risk"
    Using a self-hosted runner can potentially be dangerous. If a malicious actor
    were to open a Merge Request containing exploit code, they could potentially
    execute that code on your OpenStack host. To counter this risk, you should
    adjust your repository settings so that untrusted users cannot run CI jobs
    without explicit approval.

1. Create a new Runner in your GitLab repository settings, with the tag
   `openstack`, and set the token environment variable on your local system.

    ```sh
    export GITLAB_RUNNER_TOKEN=<your-gitlab-runner-token>
    ```

1. Go back to the *Runners* page, find the ID number of the runner, and set
   the ID environment variable on your local system.

    !!! tip
        The ID number will be in the format `#12345678`. Do NOT include the hash
        sign when setting the variable, only the digits.

    ```sh
    export GITLAB_RUNNER_ID=<your-gitlab-runner-id>
    ```

1. Run `99-gitlab-runner.yml` against your OpenStack host.

    ```sh
    ansible-playbook -i <node-ip-address>, 99-gitlab-runner.yml
    ```

1. Refresh the *Runners* page in GitLab, and make sure your new runner has
   connected.
