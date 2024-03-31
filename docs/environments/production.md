# Production (FCOS Server)

The Production environment is a single instance that runs on Fedora CoreOS.
 It's designed to be simple, secure, and low maintenance.

---

## Deployment

Now that we've completed all of the prerequisite steps, actually deploying the
 production environment is very simple.

### Triggering the Pipeline

First, we need to manually trigger the initial pipeline run.

1. In your GitLab project, go to **Build >> Pipelines**, and choose
   **Run pipeline**.

1. Select either the `main` branch, or the latest tagged version.

    !!!note
        While the main branch is the source of truth for this project, it may
        sometimes be in an undesirable state to fork from. Git tags are
        provided to denote stable points in the project's history, and are
        guaranteed to be suitable as a starting point. If you use a tag, don't
        forget you'll also need to force push it to your `main` branch!

1. Choose **Run pipeline** again to begin the process.

### Review the Terraform Plan

As you watch the pipeline graph progress, you will notice that it stops before
 the final job, called `terraform:apply`. The initial pipeline run stops at
 this stage so that you have a change to review the Terraform plan.

To view the plan, click on the `terraform:plan` job to see its log.

If you are satisfied with the plan, head back to the pipeline graph, and click
 the *Play* button next to the `terraform:apply` job. The deployment can take
 several minutes to complete.

If all goes well, you will see a green checkmark appear like the other jobs.
 This indicates that you have successfully deployed the production environment!

---

## Configure the Applications

After the initial deployment, you will need to manually configure each of the
 services for the first time. Alternatively, if you already have a backup, you
 can [Restore from backup](#restore-from-backup).

1. SSH into the running production instance.

    ```sh
    ssh core@<server-ip-address>
    ```

1. Head to the `/srv` directory, where the configurations are stored.

    ```sh
    cd /srv
    ```

### Media Frontend

There are two services make up the frontend of the media server stack -
 **Jellyfin** and **Jellyseerr**.

#### Jellyfin

Excellent documentation on configuring Jellyfin can be found on the
 [Jellyfin Docs](https://jellyfin.org/docs) page.

#### Jellyseerr

Configuring Jellyseerr is fairly straightforward, just follow the interactive
 setup wizard.

### Media Backend

There are four services that make up the backend of the media server stack -
 **Prowlarr**, **Radarr**, **Sonarr**, and **SABnzbd**. These services work
 in unison to search and acquire media from the internet sources that you
 configure.

#### Prowlarr, Radarr, and Sonarr

Excellent documentation on **Prowlarr**, **Radarr**, and **Sonarr** can be
 found on the [Servarr Wiki](https://wiki.servarr.com).

#### SABnzbd

Excellent documentation for **SABnzbd** can be found on the
 [SABnzbd Wiki](https://sabnzbd.org/wiki).

### Home Automation

The home automation stack is comprised of **Home Assistant**, and
 **Mosquitto**. Both are relatively easy to configure.

#### Home Assistant

To configure **Home Assistant**, it is recommended that you visit the
 [Home Assistant docs](https://www.home-assistant.io/docs) page.

#### Mosquitto

To configure **Mosquitto**:

1. Generate a password file for the Mosquitto MQTT broker.

    ```sh
    printf "mqtt:$(openssl passwd -6)" > /srv/mosquitto/passwd
    ```

1. Create `/srv/mosquitto/mosquitto.conf` with the following content.

    ```sh title="/srv/mosquitto/mosquitto.conf"
    listener 1883
    password_file /mosquitto/config/passwd
    log_dest stdout
    ```

---

## Backup and Restore

The backup and restore system uses [Restic](https://restic.net), and the
 `backupctl` command, to perform automatic, incremental backups of config
 data and databases.

!!! note
    Run `backupctl --help` for more information about the `backupctl` command.

!!! note
    Performing a backup or restore operation will cause temporary downtime
    of the applications.

!!! note
    Due to cloud storage costs, we are not taking backups of the media volume.

### Creating a backup

There is generally no need to manually create backups, they are performed
 automatically every night at 4:00am. If you do need to take a manual backup,
 you can either start the systemd service or use the `backupctl` command.

1. SSH into the instance.

    ```sh
    ssh core@<server-ip-address>
    ```

1. Create a backup by starting the service, or using the `backupctl` command.

    ```sh
    sudo systemctl start restic.service
    ```

    OR

    ```sh
    sudo backupctl create
    ```

### Restore from backup

If you have an existing backup created using this system, you can easily
 restore it to a fresh production server using the `backupctl` command.

1. SSH into the instance.

    ```sh
    ssh core@<server-ip-address>
    ```

1. (Optional) List the snapshots available for restore.

    ```sh
    sudo restic snapshots
    ```

1. Restore a snapshot directly to the local filesystem.

    ```sh
    # Restore the latest snapshot
    sudo backupctl restore latest

    # Restore a specific snapshot using its SHA-1 ID tag
    sudo backupctl restore <sha-1-id>
    ```
