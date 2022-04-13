#!/bin/bash

# USAGE:
#   create-template.sh {name} {/path/to/image.qcow2} {filesystem}
#
# EXAMPLE:
#   create-template.sh my-template /rpool/data/images/my-image.qcow2 local-zfs

# NOTE: This script is not idempotent, it will always create a new template.

_create_template_vm() {
    # Create a new VM
    qm create \
        "$_vmid" \
        --name "$_template_name" \
        --memory 1024 \
        --net0 virtio,bridge=vmbr0 || return 1

    # Import the disk image from local storage
    qm importdisk "$_vmid" "$_image_path" "$_filesystem" || return 1

    # Configure the VM to use the image
    qm set "$_vmid" --scsihw virtio-scsi-pci --scsi0 \
        "$_filesystem:vm-$_vmid-disk-0" || return 1

    # Add the cloud-init config drive
    qm set "$_vmid" --ide2 "$_filesystem:cloudinit" || return 1

    # Restrict the machine to boot only from the image
    qm set "$_vmid" --boot c --bootdisk scsi0 || return 1

    # Template the VM
    qm template "$_vmid" || return 1
}

_destroy_template_vm() {
    local _vmid

    # Get ID of existing VM
    _vmid="$(qm list | awk '{ print $1, $2 }' | grep "$_template_name"$ |\
        awk '{ print $1 }')" || return 1

    # Destroy the VM
    qm destroy "$_vmid" || return 1
}

_find_free_vmid() {
    for (( i=9999; i>=100; i-- )) ; do
        if ! qm list | awk '{ print $1 }' | grep ^"$i"$ &> /dev/null ; then
            if ! pct list | awk '{ print $1 }' | grep ^"$i"$ &> /dev/null ; then
                printf "Found free VMID: %s\n" "$i"
                _vmid="$i"
                break
            fi
        fi
    done
}

_main() {
    _filesystem="$3"
    _image_path="$2"
    _template_name="$1"

    if [[ "$#" -eq 3 ]] ; then
        if qm list | awk '{ print $2 }'| grep ^"$_template_name"$ &> /dev/null ; then
            _destroy_template_vm || return 2
        fi
        _find_free_vmid
        if _create_template_vm "$_image_path" "$_filesystem" ; then
            printf "\nSUCCESS!\n\n"
            return 0
        else
            printf "\nSomething went wrong!\n\n"
            return 2
        fi
    else
        printf "\nInvalid argument count!\n\n"
        return 2
    fi
}

_main "$@" || exit "$?"
