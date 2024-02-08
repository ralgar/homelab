# Managing Cinder Volumes

If you are redeploying OpenStack, or migrating from another platform, you may
 have existing LVM volumes that you wish to import. To achieve this, you can
 use the `cinder` command.

If you do not have any existing LVM volumes to import, then you can ignore this.

## Dependencies

- [python-cinderclient](https://pypi.org/project/python-cinderclient/)

## Import a volume

1. Copy the credentials file from the OpenStack host to your local system.

    ```sh
    scp root@<openstack-host-ip>:/etc/kolla/admin-openrc.sh /tmp/admin-openrc.sh
    ```

1. Source the credentials file.

    ```sh
    source /tmp/admin-openrc.sh
    ```

1. Import the volume using the `cinder manage` subcommand.

    ```sh
    # Command format
    cinder manage <host> <volume-identifier> --name <desired-name>

    # Example
    cinder manage openstack.homelab.internal lvol1 --name my-cinder-volume
    ```

## Exporting a volume

Should you need to, you can also export a Cinder volume. This can be useful if
 you ever need to reconfigure Cinder.

```sh
cinder unmanage my-cinder-volume
```
