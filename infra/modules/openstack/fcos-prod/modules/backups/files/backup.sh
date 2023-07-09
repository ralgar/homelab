#!/bin/bash

containers_list=(
    "cloudflared.service"
    "hass.service"
    "jellyfin.service"
    "jellyseerr.service"
    "mosquitto.service"
    "nzbget.service"
    "prowlarr.service"
    "radarr.service"
    "sonarr.service"
    "swag.service"
)

# Restic prune settings
KEEP_DAILY=14
KEEP_WEEKLY=16
KEEP_MONTHLY=18

function containers
{
    local error

    case $1 in
        start)
            for container in "${containers_list[@]}" ; do
                if ! systemctl start "$container" ; then
                    echo "ERROR: Failed to start $container"
                    error=1
                fi
            done
            ;;
        stop)
            for container in "${containers_list[@]}" ; do
                if ! systemctl stop "$container" ; then
                    echo "ERROR: Failed to stop $container"
                    error=1
                fi
            done
            ;;
        *)
            echo "ERROR: Unknown argument"
            return 1
            ;;
    esac

    [[ $error ]] && return 1
}

function create_backup
{
    local error

    # Create the backup. If it fails we return immediately since we
    #  do not want to prune old backups while creation is failing.
    if ! restic backup /var/srv ; then
        echo "ERROR: Backup creation failed!"
        return 1
    fi

    # Prune the repository
    if ! restic forget --prune \
        --keep-daily "$KEEP_DAILY" \
        --keep-weekly "$KEEP_WEEKLY" \
        --keep-monthly "$KEEP_MONTHLY"
    then
        echo "ERROR: Repository prune operation failed!"
        error=1
    fi

    # Check repository data structures
    if ! restic check ; then
        echo "ERROR: Repository integrity check failed!"
        error=1
    fi

    [[ $error ]] && return 1
}

function main
{
    local error

    # We must be root as we require access to directories with very
    #  restrictive permissions owned by multiple different UIDs.
    if [[ $EUID -ne 0 ]] ; then
        echo "ERROR: This script must be run as root!"
        return 1
    fi

    # Restic configuration variables are set in /etc/environment.
    source /etc/environment || return 1

    # Initialize the repo if needed.
    if ! restic snapshots &> /dev/null ; then
        restic init || return 1
    fi

    # Some of the containers rely on SQLite, so we stop them before
    #  creating the backup, and then start them again after.
    containers stop || error=1
    create_backup || error=1
    containers start || error=1

    [[ $error ]] && return 1
}

main || exit 1
