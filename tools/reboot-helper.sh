#!/usr/bin/env bash
set -euo pipefail

NODE="talos-aio"

ROOK_CLUSTER_NAMESPACES="ceph-premium ceph-standard"

# This needs to contain everything that
APP_NAMESPACES="authentik forgejo media-server monitoring smart-home vault"

function before_reboot
{
    local ns

    # Protect Ceph clusters from unnecessary rebalancing.
    for ns in $ROOK_CLUSTER_NAMESPACES; do
        kubectl -n "$ns" exec deploy/rook-ceph-tools -- ceph osd set noout
    done

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

    # Drain everything remaining, excluding the Rook operator and MONs.
    kubectl drain "$NODE" \
        --ignore-daemonsets --delete-emptydir-data \
        --pod-selector='app!=rook-ceph-operator,app!=rook-ceph-tools,app!=rook-ceph-mon'

    # Drain the operator and mons
    kubectl drain "$NODE" \
        --ignore-daemonsets --delete-emptydir-data \
        --pod-selector='app=rook-ceph-operator,app=rook-ceph-tools,app=rook-ceph-mon'
}

function after_reboot
{
    # Uncordon the node so applications scale up again.
    kubectl uncordon "$NODE"

    # Unset noout after Ceph OSDs come back online.
    for ns in $ROOK_CLUSTER_NAMESPACES; do
        printf "Waiting for Ceph cluster to become healthy: %s\n" "$ns"
        until ceph_osds_online "$ns"; do
            sleep 5
        done
        kubectl -n "$ns" exec deploy/rook-ceph-tools -- ceph osd unset noout
    done
}

function ceph_osds_online
{
    local ns="$1"

    if kubectl -n "$ns" exec deploy/rook-ceph-tools -- ceph status --format json |
        jq -e '
            .osdmap.num_osds == .osdmap.num_up_osds and
            .osdmap.num_osds == .osdmap.num_in_osds and
            .pgmap.num_pgs > 0 and
            all(.pgmap.pgs_by_state[]; (.state_name | startswith("active+clean")))
        ' &> /dev/null
    then
        return 0
    else
        return 1
    fi
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
