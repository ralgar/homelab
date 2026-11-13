#!/usr/bin/env bash
set -euo pipefail

NODE="talos-aio"

# This needs to contain everything that
APP_NAMESPACES="authentik forgejo media-server monitoring smart-home vault"

function before_reboot
{
    local ns

    # Cordon the node so replacement pods cannot schedule onto it.
    kubectl cordon "$NODE"

    # Delete all pods in the application namespaces.
    for ns in $APP_NAMESPACES ; do
        # Remove DB consumers first
        kubectl -n "$ns" delete pods --wait=true \
            --field-selector="spec.nodeName=$NODE,status.phase=Running" \
            -l '!postgres-operator.crunchydata.com/cluster'

        # Followed by the DBs themselves
        kubectl -n "$ns" delete pods --wait=true \
            --field-selector="spec.nodeName=$NODE,status.phase=Running" \
            -l 'postgres-operator.crunchydata.com/cluster'
    done

    # Drain everything remaining, including Rook.
    kubectl drain "$NODE" --ignore-daemonsets --delete-emptydir-data
}

function after_reboot
{
    # Uncordon the node so applications scale up again.
    kubectl uncordon "$NODE"
}

# Command dispatch
case "${1:-}" in
    --before-reboot)
        before_reboot
        ;;
    --after-reboot)
        after_reboot
        ;;
    *)
        echo "Usage: $0 {--before-reboot|--after-reboot}" >&2
        exit 1
        ;;
esac
