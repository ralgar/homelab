# CI/CD Configuration

The final step, before we can start deploying workloads, is to configure the
 CI/CD settings.

!!! tip
    This section is extremely important. If you do not configure the CI/CD
    correctly, the pipelines will not run as intended.

---

## Setting the CI/CD variables

In your GitLab project, go to **Settings >> CI/CD**, and expand the
 **Variables** section.

1. Create a variable *file* named `OS_CLOUDS`, with the contents of your
   `metal/output/clouds.yaml` file that was generated when deploying
   OpenStack.

1. Create a variable *file* named `TF_VARS_FILE`, with the following contents.

    ```hcl title="TF_VARS_FILE"
    restic_password = "<your-restic-repository-password>"

    // See https://rclone.org/drive for setup documentation.
    // NOTE: All double quotes within the token JSON string must be escaped.
    gdrive_oauth = {
      client_id = "<your-gdrive-client-id>"
      client_secret = "<your-gdrive-client-secret>"
      token = "<your-gdrive-oauth-token>"
      root_folder_id = "<your-gdrive-root-folder-id>"
    }
    ```

---

## Merge Requests configuration

In your GitLab project, go to **Settings >> Merge Requests**.

1. Set **Merge Method** to *Fast-forward Merge.*

1. Set **Squash Merging** to *Require.*

1. Under **Merge Checks**, enable *Pipelines must succeed.*

1. Set the **Squash commit message template**, like so.

    ```conf
    %{title}

    %{description}

    MR: %{url}
    ```
