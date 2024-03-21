#!/bin/bash

containers_list=(
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
KEEP_DAILY=7
KEEP_WEEKLY=5
KEEP_MONTHLY=12

# Manually define HOME if unset (may be running as systemd service)
[[ -z $HOME ]] && export HOME=/root

function containers
{
    local status=0

    case $1 in
        start)
            for container in "${containers_list[@]}" ; do
                if ! systemctl start "$container" ; then
                    echo "ERROR: Failed to start $container"
                    status=1
                fi
            done
            ;;
        stop)
            for container in "${containers_list[@]}" ; do
                if ! systemctl stop "$container" ; then
                    echo "ERROR: Failed to stop $container"
                    status=1
                fi
            done
            ;;
        *)
            echo "ERROR: Unknown argument"
            return 1
            ;;
    esac

    return $status
}

function create_backup
{
    local status=0

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
        status=1
    fi

    # Check repository data structures
    if ! restic check ; then
        echo "ERROR: Repository integrity check failed!"
        status=1
    fi

    return $status
}

function main
{
    local status=0

    # We must be root as we require access to directories with very
    #  restrictive permissions owned by multiple different UIDs.
    if [[ $EUID -ne 0 ]] ; then
        echo "ERROR: This script must be run as root!"
        return 1
    fi

    # Restic configuration variables are set in /etc/environment.
    source /etc/environment || return 1

    # Initialize the repo if uninitialized.
    if ! restic cat config &> /dev/null ; then
        restic init || return 1
    fi

    # Some of the containers rely on SQLite, so we stop them before
    #  creating the backup, and then start them again after.
    containers stop || status=1
    create_backup || status=1
    containers start || status=1

    return $status
}

main
exit $?
