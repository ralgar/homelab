# Deploying Kubernetes

If you've satisfied the [Prerequisites](./prerequisites.md) and completed all
 of the required [Configuration](./configuration.md) then you are now ready to
 deploy the bare-metal Kubernetes cluster.

---

## Deploying the Talos Cluster

1. Obtain a Talos Linux ISO and write it to a USB or use PXE boot to boot it
   on your node(s). When Talos boots up it should be in **Maintenance** mode.

1. Run `terraform apply` from the `metal/` directory.

Terraform will bootstrap the Talos node(s), then deploy the Flux CD controller
 and immediately begin reconciling the cluster applications from Git.

**With that, your cluster should now be fully up and running!**
