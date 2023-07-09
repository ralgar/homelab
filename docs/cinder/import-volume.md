# Importing and exporting Cinder volumes

We can import and export OpenStack volumes using the legacy `cinder` command.

## Import a volume

1. Source your credentials variables file.

   ```sh
   source admin-openrc.sh
   ```

1. Import the volume using the `cinder manage` subcommand.

   ```sh
   # Command format
   cinder manage <host> <volume-identifier> --name <desired-name>

   # Example
   cinder manage openstack.homelab.internal lvol1 --name my-cinder-volume
   ```

## Exporting a volume

   ```sh
   cinder unmanage my-cinder-volume
   ```
