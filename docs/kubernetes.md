# Kubernetes Cluster

The included Kubernetes cluster is currently in development (alpha status),
 primarily due to the fact that some of the core applications still rely on
 SQLite. Once support for a proper RDBMS has been added to all applications,
 the Kubernetes cluster will be moved into production.

---

## Deployment

1. Use the included `Makefile` to provision the cluster infrastructure.

    ```sh
    make cluster
    ```

1. Once the cluster has finished provisioning, verify it is operational.

    ```sh
    # Set kubectl to use the output kube config file from the previous step
    export KUBECONFIG=output/kube_config

    # Use kubectl to list all pods in the cluster
    kubectl get pods -A
    ```

    You should see Flux working to deploy the cluster applications.

---

## Making changes

In order to make your own changes to the cluster, you will need to fork
 this repository, alter the Flux configuration to point to your new GitOps
 repository, and re-deploy the cluster. Once this is done, you can commit
 changes to your repository, and Flux will automatically apply them to the
 cluster.

Apps are deployed to the cluster by use of the `cluster` directory.

1. Add or edit Kubernetes manifests, or Helm charts, in
   `cluster/<category>/<app-name>`.
1. Commit the changes in `git`, and push them to your repository.

---

## Destroying the cluster

To completely destroy the cluster infrastructure:

```sh
make destroy-cluster
```
