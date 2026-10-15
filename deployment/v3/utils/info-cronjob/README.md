# info-cronjob

A daily Kubernetes CronJob that collects every Deployment, StatefulSet, DaemonSet and CronJob in the cluster with its container images and ready status, and publishes the result at `https://<public-api-host>/info`:

* Browsers get an interactive dashboard (search, filters, health per namespace, image/version drift view, CSV export).
* `curl` and scripts get the plain-text report, in the same format as the older [info](../info) Helm chart.
* Raw data is at `/info/info.json` and `/info/info.txt`.

It works in any environment: nothing environment-specific is stored in the manifests; it is supplied at install time. This replaces the `info` Helm chart (an nginx + `crond` pod that reserved ~3 GiB of memory). Tracked in [#1965](https://github.com/mosip/mosip-infra/issues/1965).

## How it works

| Component | Purpose |
| --- | --- |
| CronJob `info` | Runs [`base/fetch-info.sh`](base/fetch-info.sh) on a schedule in `alpine/k8s` and writes `info.json` + `info.txt` into ConfigMap `info-output`. |
| Deployment `info` | `nginx` serving [`base/index.html`](base/index.html) and the `info-output` ConfigMap. [`base/nginx.conf`](base/nginx.conf) returns HTML or text at `/info` based on the `Accept` header. |
| VirtualService `info` | Routes `/info` and `/info/*` on the configured Istio gateway(s). |
| ServiceAccount / RBAC | Cluster-wide read-only access to namespaces and workloads; write access only to the `info-output` ConfigMap in the `info` namespace. |

## Install

```sh
[SETTING=value ...] ./install.sh [kubeconfig]
```

| Setting | Default | Meaning |
| --- | --- | --- |
| `ENV_NAME` | prompted; suggests the current kube context name | Name shown on the dashboard and written to `info.json`. |
| `SCHEDULE` | `0 2 * * *` | Cron schedule, in cluster time (normally UTC). |
| `GATEWAY` | `istio-system/public` | Istio gateway(s) serving `/info`, comma separated. |
| `EXCLUDED_NAMESPACE` | `^(istio\|cattle\|kube\|info)` | Regex of namespaces left out of the report. |
| `DRY_RUN` | unset | `1` prints the rendered manifests instead of applying them. |

Examples:

```sh
./install.sh ~/.kube/collab.yaml                       # prompts for the environment name
ENV_NAME=released ./install.sh ~/.kube/released.yaml
ENV_NAME=synergy SCHEDULE="30 3 * * 1-5" GATEWAY=istio-system/internal ./install.sh ~/.kube/synergy.yaml
ENV_NAME=qa DRY_RUN=1 ./install.sh                     # review before applying
```

The script creates the `info` namespace with Istio injection, removes the old `info` Helm release if present (after confirmation), applies the manifests and runs the collector once. Re-run it with new settings to change them.

## Run the collector on demand

```sh
kubectl -n info create job --from=cronjob/info info-manual-$(date +%s)
```

The dashboard picks up the new data within about a minute; nginx does not need a restart.

## Changing the dashboard or nginx config

Edit [`base/index.html`](base/index.html) or [`base/nginx.conf`](base/nginx.conf) and re-run `install.sh`. Dashboard changes are served within a minute; after an nginx config change also run `kubectl -n info rollout restart deploy/info`.

## Uninstall

```sh
./delete.sh [kubeconfig]
```
