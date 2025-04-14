# Windows Images (Optional)

This project provides Packer templates for automating the creation of
 preconfigured Windows Server cloud images. These images are designed to
 function just like Linux cloud images, offering built-in support for SSH
 access using public key authentication.

These are completely optional, and not currently used in any deployments.

---

## Using the Images

### Dependencies

In order to build the images, you must provide two ISO image files - a
 **Windows Server 2019** image (non-evaluation version), and a **VirtIO
 Windows Drivers** image. These should be placed in the `templates/iso/`
 directory, and should be named `windows-server-2019.iso` and
 `virtio-win.iso` respectively.

You will also need to ensure the following dependencies are installed on your
 local system:

- [Ansible](https://www.ansible.com/)
- [Packer](https://packer.io/)
- [QEMU](https://qemu.org/)

### Building with Packer

Once you've satisfied the dependencies, building is simple.

!!! note
    Due to current limitations in the Packer OpenStack builder, we are
    unable to use it for building the Windows Server images directly on
    OpenStack at this time, as the images require multiple ISOs and files to
    be attached. As such, the images must be built on your local system using
    QEMU, and then manually uploaded to OpenStack.

!!! warning
    Packer will execute all builds in parallel by default. Each image requires
    2 CPU cores and 4 GB of RAM. Ensure you have adequate system resources
    available, and/or set parallelism to an appropriate value using the Packer
    CLI option `-parallel-builds=1`.

1. From the `templates/` directory, start the build(s).

    ```bash
    cd templates
    packer build -parallel-builds=2 .
    ```

1. If the builds were successful, you will find the resultant images in the
   output directories:

    ```text
    templates/output-windows_2019_core/
    templates/output-windows_2019_desktop/
    ```

### Uploading to OpenStack

Once the images are built, they are ready to be uploaded and used with
 OpenStack.

The minimum disk size must be set to **32 GB** and, according to Microsoft, the
 minimum memory requirement is **512 MB** for Core and **2048 MB** for Desktop.
