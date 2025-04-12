# Ceph: Dashboard Access

Cephadm automatically generates a user account and random password for the
 dashboard (web UI), however we do not currently collect this during
 deployment of the cluster. If you wish to access the dashboard, simply reset
 the `admin` user's password.

!!! NOTE
    The dashboard is available at: `https://<your-openstack-host>:8443`

## Reset the admin password

```sh
printf "mysupersecurepassword" | ceph dashboard ac-user-set-password admin -i -
```
