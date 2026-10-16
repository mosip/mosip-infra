# info (deprecated)

This Helm-based utility is **deprecated**. It installs into the same `info` namespace with the same resource names as [`../info-cronjob`](../info-cronjob), so running `./install.sh` here after info-cronjob causes Helm ownership conflicts.

Use **[info-cronjob](../info-cronjob)** instead:

```sh
ENV_NAME=<env> ../info-cronjob/install.sh [kubeconfig]
```

`./install.sh` in this directory exits with an error pointing at that path. `delete.sh` / `restart.sh` remain only for cleaning up an old Helm release if one is still present.
