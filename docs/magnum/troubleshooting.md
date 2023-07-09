# Magnum Troubleshooting

## Error: Cluster type not supported

**When attempting to create a Kubernetes cluster with Magnum, OpenStack would
  return the error *"Cluster type (vm, None, kubernetes) not supported."***

This error was a chore to diagnose because it is *very* misleading. The error
 itself would indicate that there is something wrong with the provided `coe`
 argument. However the actual problem is that the `os_distro` metadata must
 be correctly set to `fedora-coreos` for the referenced image.
