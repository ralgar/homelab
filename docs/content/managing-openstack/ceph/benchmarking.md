# Ceph: Benchmarking

If you wish to test the performance of your Ceph storage cluster, you can
 perform a simple benchmark using the built-in commands.

I hit ~400 MB/s throughput with my 8 drive Ceph cluster, which is pretty good!

## Create a benchmark pool

1. Start by creating a new pool for benchmarking.

    ```sh
    ceph osd pool create <pool-name> 128 128
    ```

## Run the benchmarks

1. Run a write benchmark first to create some data.

    ```sh
    rados bench -p <pool-name> 20 write --no-cleanup
    ```

1. Then run sequential and random read benchmarks.

    ```sh
    rados bench -p <pool-name> 20 rand --no-cleanup
    rados bench -p <pool-name> 20 seq --no-cleanup
    ```

1. Clean up benchmark objects.

    ```sh
    rados -p <pool-name> cleanup
    ```

## Destroy the benchmark pool

1. Enable pool deletion.

    ```sh
    ceph config set mon mon_allow_pool_delete true
    ```

1. Delete the pool (you *must* specify the name twice).

    ```sh
    ceph osd pool delete <pool-name> <pool-name> --yes-i-really-really-mean-it
    ```

1. Disable pool deletion again.

    ```sh
    ceph config set mon mon_allow_pool_delete false
    ```
