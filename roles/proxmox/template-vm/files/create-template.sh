#!/bin/bash

# USAGE:
#   create-template.sh {name} {/path/to/image.qcow2} {filesystem}
#
# EXAMPLE:
#   create-template.sh my-template /rpool/data/images/my-image.qcow2 zfs

_create_template_vm() {
    # Create a new VM
    qm create \
        "$_vmid" \
        --name "$_template_name" \
        --memory 1024 \
        --net0 virtio,bridge=vmbr0 || return 1

    # Import the disk image from local storage
    qm importdisk "$_vmid" "$_image_path" "local-$_filesystem" || return 1

    # Configure the VM to use the image
    qm set "$_vmid" --scsihw virtio-scsi-pci --scsi0 \
        "local-$_filesystem:vm-$_vmid-disk-0" || return 1

    # Add the cloud-init config drive
    qm set "$_vmid" --ide2 "local-$_filesystem:cloudinit" || return 1

    # Restrict the machine to boot only from the image
    qm set "$_vmid" --boot c --bootdisk scsi0 || return 1

    # Template the VM
    qm template "$_vmid" || return 1
}

_find_free_vmid() {
    for (( i=100; i<=10000; i++ )) ; do
        if ! qm list | awk '{ print $1 }' | grep ^"$i"$ &> /dev/null ; then
            if ! pct list | awk '{ print $1 }' | grep ^"$i"$ &> /dev/null ; then
                printf "Found free VMID: %s\n" "$i"
                _vmid="$i"
                break
            fi
        fi
    done
}

_filesystem="$3"
_image_path="$2"
_template_name="$1"


if [[ "$#" -eq 3 ]] ; then
    if ! qm list | grep "$_template_name" &> /dev/null ; then
        _find_free_vmid
        if _create_template_vm "$_image_path" "$_filesystem" ; then
            printf "\nSUCCESS!\n\n"
            exit 0
        else
            printf "\nSomething went wrong!\n\n"
            exit 2
        fi
    else
        printf "\nThe specified template already exists!\n\n"
        exit 1
    fi
else
    printf "\nInvalid argument count!\n\n"
    exit 2
fi
