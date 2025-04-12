# Deploying OpenStack

If you don't already have an OpenStack cloud available, you can use the
 included `metal/` module to deploy a single-node lab. For multi-node
 labs you will need to modify the included Ansible roles, or follow the
 [Kolla Ansible documentation](https://docs.openstack.org/kolla-ansible/zed/)
 to manually deploy your own.

---

## Initial Configuration

Before we begin deployment, we need to configure everything under the
 highlighted keys in `metal/vars/main.yml`:

!!!tip
    It is strongly recommended to use consistent identifiers to define
    your block devices, such as the WWN identifiers from `/dev/disk/by-id`.

```yaml title="metal/vars/main.yml" hl_lines="7 11 14 34 44"
common:
  # Name (path) of the venv, using the root user's home as the base.
  # Ex. A value of 'kolla-venv' will become '/root/kolla-venv'
  venv: kolla-venv

  # Path to your SSH pubkey file. This will be used to access the node.
  ssh_pubkey_file: ~/.ssh/id_ed25519.pub

storage:
  # Target block device for the Openstack host's root filesystem.
  root_device: /dev/disk/by-id/nvme-WD_BLACK_SN770_1TB_23020Q804222

  # Target block device(s) for Ceph (OpenStack volume/shared/object storage)
  ceph_osds:
    - /dev/disk/by-id/wwn-0x6b8ca3a0faf798002bd0bf3c11919471
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
  dns_servers: ['1.1.1.1', '1.0.0.1']

  # Configure the OpenStack internal provider network - where SSH and the
  #  OpenStack WebUI and APIs will be exposed.
  # This should connect to your internal (private) LAN.
  internal:
    interface: eno1
    ip_address: 10.254.20.11
    network_cidr: 10.254.20.0/24
    gateway_addr: 10.254.20.1

  # Configure external provider network(s), where OpenStack can create
  #  publicly-accessible IP addresses for your infrastructure.
  # These should be internal DMZs, or public subnets assigned by your ISP.
  # NOTE: If using VLANs, use a contiguous range (eg. 10-14 or 20-29).
  external:
    interface: eno2
    type: vlan                          # Must be one of 'flat' or 'vlan'.
    networks:
      - name: public                    # Name to assign the network.
        vlan_id: 10                     # Specify a VLAN ID.
        network_cidr: 10.254.10.0/24    # Network address in CIDR notation.
        gateway_addr: 10.254.10.1       # IP address of the default gateway.
        dhcp_pool_start: 10.254.10.10   # Start IP of the DHCP pool.
        dhcp_pool_end: 10.254.10.254    # End IP of the DHCP pool.
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

1. After it has finished rebooting, SSH into your new node to confirm that
   it's ready.

    ```sh
    ssh root@<node-ip-address>
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
