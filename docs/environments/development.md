# Development (K8s Cluster)

The included Kubernetes cluster is currently in development (beta status), and
 resides in the development environment. It will be migrated into production
 starting with `v3.0.0`.

---

## Deployment

1. Set the following environment variables.

    ```sh
    export GOOGLE_CREDENTIALS=/path/to/gcloud/credentials.json
    export KUBECONFIG=output/kube_config
    ```

1. Use the included `Makefile` to provision the cluster infrastructure.

    ```sh
    make apply
    ```

1. Once the cluster has finished provisioning, verify it is operational.

    ```sh
    kubectl get pods -A
    ```

    You should see Flux working to deploy the cluster applications.

---

## Making changes

All cluster state is handled by Flux. In order to make your changes to the
 cluster, you simply need to commit and push changes to the code respository.

Apps are deployed to the cluster by use of the `cluster` directory.

1. From `main`, create and checkout a new branch, and push it to your remote.

    ```sh
    git checkout -b my-new-branch
    git push -u origin my-new-branch
    ```

1. Apply the infrastructure again to have Flux reconcile from your new branch.

    ```sh
    make apply
    ```

1. Add or edit Kubernetes manifests, or Helm charts, in
   `cluster/<category>/<app-name>`. You may also need to adjust the sync
   configuration in `cluster/system/flux-sync`.

1. Commit your changes, and push them to your remote. Flux will automatically
   pick them up and apply them within a few minutes.

---

## Destroying the environment

!!!warning
    The dev environment is completely ephemeral. Destroying it will delete
    everything, including backups.

To completely destroy the development infrastructure:

```sh
make destroy
```
