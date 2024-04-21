#!/bin/bash

# Restic prune settings
KEEP_DAILY=7
KEEP_WEEKLY=5
KEEP_MONTHLY=12

# Manually define HOME if unset (may be running as systemd service)
[[ -z $HOME ]] && export HOME=/root


function check_privileges
{
    # We must be root as we require access to directories with very
    #  restrictive permissions owned by multiple different UIDs.
    if [[ $EUID -ne 0 ]] ; then
        echo "ERROR: This script must be run as root!"
        return 1
    else
        return 0
    fi
}


function containers
{
    local status=0

    local containers_list=()

    for container in /srv/* ; do
        containers_list+=("${container#/srv/}")
    done

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

    # Validate positional arguments
    if [[ $# -ne 0 ]] ; then
        echo -e "backupctl: Unrecognized arguments: $*"
        echo "Try 'backupctl --help' for more information."
        return 1
    fi

    check_privileges || return 1

    # Initialize the repo if uninitialized.
    if ! restic cat config &> /dev/null ; then
        restic init || return 1
    fi

    # Some of the containers rely on SQLite, so we stop them before
    #  performing operations, and then start them again after.
    containers stop || return 1

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

    containers start || status=1

    return $status
}


function print_help_dialog
{
    echo "Usage: backupctl [COMMAND]"
    echo
    echo "COMMANDs:"
    echo "  create                     Stop server and create a new snapshot"
    echo "  restore [SNAPSHOT]         Stop server and restore a snapshot"
    echo
    echo "The SNAPSHOT argument can be either 'latest', or a specific snapshot ID"
    echo "as found in the output of the 'restic snapshots' command."
    echo
    echo "Exit Status:"
    echo "  0                          Everything went OK"
    echo "  1                          Something went wrong"
}


function restore_backup
{
    local status=0

    # Validate positional arguments
    if [[ $# -ne 1 ]] ; then
        echo -e "backupctl: Unrecognized arguments: $*"
        echo "Try 'backupctl --help' for more information."
        return 1
    fi

    check_privileges || return 1

    # Ensure the repo is initialized.
    if ! restic cat config &> /dev/null ; then
        return 1
    fi

    # Some of the containers rely on SQLite, so we stop them before
    #  performing operations, and then start them again after.
    containers stop || status=1

    # Restore the backup.
    if ! restic restore "$1" --target / ; then
        echo "ERROR: Backup restore failed!"
        return 1
    fi

    if [[ "$(hostname -s)" == "staging" ]] ; then
        if [[ -d /srv/swag/etc/letsencrypt ]] ; then
            rm -rf /srv/swag/etc/letsencrypt/*
        fi
    fi

    containers start || status=1

    return $status
}


function main
{
    local status=0

    # Restic configuration variables are set in /etc/environment.
    source /etc/environment || return 1

    case $1 in
        create)
            shift
            create_backup "$@" || status=1
            ;;
        restore)
            shift
            restore_backup "$@" || status=1
            ;;
        --help)
            print_help_dialog
            ;;
        *)
            echo -e "backupctl: Unrecognized command '$1'"
            echo "Try 'backupctl --help' for more information."
            return 1
            ;;
    esac

    return $status
}


main "$@"
exit $?
