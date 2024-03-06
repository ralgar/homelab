# Deploying OpenStack

If you don't already have an OpenStack cloud available, you can use the
 included `metal/` module to deploy a single-node lab. For multi-node
 labs you will need to modify the included Ansible roles, or follow the
 [Kolla Ansible documentation](https://docs.openstack.org/kolla-ansible/zed/)
 to manually deploy your own.

---

## Initial Configuration

Before we begin deployment, we need to configure the variables files
 `globals.yml` and `main.yml` in `metal/vars/`.

!!! tip
    Be sure to set these correctly, otherwise the deployment will not work.

1. Search for the following values in `globals.yml`, and make sure they
   are set correctly.

    ```yaml title="metal/vars/globals.yml"
    # The desired static IP address of the node.
    kolla_internal_vip_address: "192.168.1.11"

    # The network interface that is connected to your local network.
    network_interface: "eno1"

    # The other network interface.
    # This one should NOT have an IP address, and doesn't need a connection.
    neutron_external_interface: "eno2"
    ```

1. Make sure the highlighted keys in `main.yml` are set correctly.

    !!!tip
        It is strongly recommended to use consistent identifiers to define
        your block devices, such as the WWN identifiers from `/dev/disk/by-id`.

    ```yaml title="metal/vars/main.yml" hl_lines="7 11 15 20 42 45 50 51"
    common:
      # Name (path) of the venv, using the root user's home as the base.
      # Ex. A value of 'kolla-venv' will become '/root/kolla-venv'
      venv: kolla-venv

      # Path to your SSH pubkey file. This will be used to access the node.
      ssh_pubkey_file: ~/.ssh/id_ed25519.pub

    storage:
      # Target block device for the Openstack host's root filesystem.
      root_device: /dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_23020Q804222

      cinder:
        # Target block device(s) for Cinder "standard" (HDD) tier.
        devices:
          - /dev/disk/by-id/wwn-0x6b8ca3a0faf798002bd0bf3c11919471

      swift:
        # Target block device(s) for Swift.
        devices:
          - /dev/disk/by-id/wwn-0x6b8ca3a0faf798002d7240bf3ecf84b7
          - /dev/disk/by-id/wwn-0x6b8ca3a0faf798002d7240f041b207bc
          - /dev/disk/by-id/wwn-0x6b8ca3a0faf798002d72410a433d4109
          - /dev/disk/by-id/wwn-0x6b8ca3a0faf798002d72413745f2e841

    network:
      # A domain to use for the internal OpenStack infrastructure.
      domain: homelab.internal

      # A hostname/subdomain to assign to the AIO OpenStack node.
      hostname: openstack

      # A list of two public DNS resolvers to use for the network.
      public_dns_servers: ['1.1.1.1', '1.0.0.1']

      # Desired names (within OpenStack) of your 'public' network and subnet.
      # This network is attached to your LAN.
      public_network_name: public
      public_subnet_name: public

      # CIDR of your LAN subnet.
      public_subnet_cidr: 192.168.1.0/24

      # The IP address of your LAN gateway (your router).
      public_subnet_gateway_ip: 192.168.1.254

      # Range of the floating IP address pool for public OpenStack network.
      # This should be OUTSIDE of the DHCP range of your router, and should
      #  NOT include the IP address of your gateway or your OpenStack node.
      public_subnet_allocation_pool_start: 192.168.1.20
      public_subnet_allocation_pool_end: 192.168.1.100
    ```

---

## Installing the host OS

1. Run `00-make-kickstart-iso.yml` to generate an ISO file in `output/`.

    ```sh
    ansible-playbook 00-make-kickstart-iso.yml
    ```

1. Write the ISO file to a USB drive (or use PXE boot).

    ```sh
    dd if=<iso-file> of=/dev/<usb-drive> bs=4M conv=fsync oflag=direct status=progress
    ```

1. Boot the ISO, and wait for the automated installer to finish (the system
   will reboot).

    !!!bug
        At the GRUB boot menu, you will need to press **e** to edit the kernel
        command line, and append `inst.ks=hd:LABEL=Rocky-9-0-x86_64-dvd:/ks.cfg`
        after `quiet`. Then, press **Ctrl-x** to continue.

1. SSH into your new node, and configure an additonal LVM Volume Group named
   `cinder-standard` on your disk or RAID array.

    ```sh title="Create Cinder volume group"
    # Partition a virtual device / physical disk.
    gdisk /dev/<path-to-vdev>

    # Create a Physical Volume on the partition.
    pvcreate /dev/<path-to-vdev>1

    # Create a Volume Group with the Physical Volume.
    vgcreate cinder-standard /dev/<path-to-vdev>1
    ```

---

## OpenStack Deployment

1. Run `10-deploy-openstack.yml` against your new node.

    ```sh
    ansible-playbook -i <node-ip-address>, 10-deploy-openstack.yml
    ```

1. Copy `clouds.yaml` to your OpenStack config directory.

    ```sh
    mkdir -p ~/.config/openstack
    cp output/clouds.yaml ~/.config/openstack/clouds.yaml
    ```

---

## GitLab Runner

This step will deploy a local GitLab Runner, in a Docker container, directly
 on the OpenStack host. This will be used to run CI/CD jobs within your
 network.

!!! warning "Security Risk"
    Using a self-hosted runner can potentially be dangerous. If a malicious actor
    were to open a Merge Request containing exploit code, they could potentially
    execute that code on your OpenStack host (and within your network). To counter
    this risk, you should adjust your repository settings so that untrusted users
    cannot run CI jobs without explicit approval.

### Runner Deployment

1. Create a new Runner in your GitLab repository settings, with the tag
   `openstack`, and set the token environment variable on your local system.

    ```sh
    export GITLAB_RUNNER_TOKEN=<your-gitlab-runner-token>
    ```

1. Go back to the *Runners* page, find the ID number of the runner, and set
   the ID environment variable on your local system.

    !!! tip
        The ID number will be in the format `#12345678`. Do NOT include the hash
        sign when setting the variable, only the digits.

    ```sh
    export GITLAB_RUNNER_ID=<your-gitlab-runner-id>
    ```

1. Run `99-gitlab-runner.yml` against your OpenStack host.

    ```sh
    ansible-playbook -i <node-ip-address>, 99-gitlab-runner.yml
    ```

1. Refresh the *Runners* page in GitLab, and make sure your new runner has
   connected.

## Local DNS Configuration

Your new OpenStack cloud comes with the Designate DNS service, which has been
 configured to behave as a forwarding DNS server. This allows resolution of
 local domains, while still forwarding external requests to public DNS servers.

In order to use your internal DNS, set your router's (or individual device's)
 primary DNS server to the IP address of your OpenStack node.
