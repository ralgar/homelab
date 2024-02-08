# Production Server

The Production environment is a single instance that runs on Fedora CoreOS.
 It's designed to be simple, secure, and low maintenance.

---

## Deployment

### CI/CD configuration

In your GitLab project, go to **Settings >> CI/CD**, and expand the
 **Variables** section.

1. Create a variable *file* named `OS_CLOUDS`, with the contents of your
   `metal/output/clouds.yaml` file that you generated when configuring
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

### Run the pipeline

1. In your GitLab project, go to **Build >> Pipelines**, and **Run pipeline**.

1. Select either the `main` branch (recommended), or the latest tagged version.

1. Choose **Run pipeline** again to begin the deployment.

---

## Configure the services

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
 **Prowlarr**, **Radarr**, **Sonarr**, and **NZBGet**. These services work
 in unison to search and acquire media from the internet sources that you
 configure.

Excellent documentation on **Prowlarr**, **Radarr**, and **Sonarr** can be
 found on the [Servarr Wiki](https://wiki.servarr.com).

Excellent documentation for **NZBGet** can be found on the
 [NZBGet Docs](https://nzbget.net/documentation) page.

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

The backup and restore system uses [Restic](https://restic.net), and a shell
 script, to perform automatic, incremental backups of configuration data and
 service databases.

!!! note
    Due to cloud storage costs, we are not taking backups of the media volume.

### Creating a backup

There is generally no need to manually create backups, they are performed
 automatically every night at 4:00am. If you do need to take a manual backup
 for any reason, you can simply start the systemd service.

1. SSH into the instance.

    ```sh
    ssh core@<server-ip-address>
    ```

1. Start the service.

    ```sh
    sudo systemctl start restic.service
    ```

### Restore from backup

If you have an existing backup created using this system, you can easily
 restore it to a fresh production server using a few simple commands.

1. SSH into the instance.

    ```sh
    ssh core@<server-ip-address>
    ```

1. List the snapshots available for restore.

    ```sh
    sudo restic snapshots
    ```

1. Restore a snapshot directly to the local filesystem.

    ```sh
    # Restore the latest snapshot
    sudo restic restore latest --target /

    # Restore a specific snapshot using its SHA-1 ID tag
    sudo restic restore <sha-1-id> --target /
    ```
