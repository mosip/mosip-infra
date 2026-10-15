# info-cronjob

A daily Kubernetes CronJob that collects every Deployment, StatefulSet, DaemonSet and CronJob in the cluster with its container images and ready status, and publishes the result at `https://<internal-api-host>/info` (the `istio-system/internal` gateway by default):

* Browsers get an interactive dashboard (search, filters, health per namespace, image/version drift view, CSV export).
* `curl` and scripts get a plain-text report (see [Output](#output); its format differs from the older [info](../info) Helm chart).
* Raw data is at `/info/info.json` and `/info/info.txt`.

It works in any environment: nothing environment-specific is stored in the manifests; it is supplied at install time. This replaces the `info` Helm chart (an nginx + `crond` pod that reserved ~3 GiB of memory). Tracked in [#1965](https://github.com/mosip/mosip-infra/issues/1965).

## How it works

| Component | Purpose |
| --- | --- |
| CronJob `info` | Runs [`base/fetch-info.sh`](base/fetch-info.sh) on a schedule in `alpine/k8s` and writes `info.json` + `info.txt` into ConfigMap `info-output`. |
| Deployment `info` | `nginx` serving [`base/index.html`](base/index.html) and the `info-output` ConfigMap. [`base/nginx.conf`](base/nginx.conf) returns HTML or text at `/info` based on the `Accept` header. |
| VirtualService `info` | Routes `/info` and `/info/*` on the configured Istio gateway(s). |
| ServiceAccount / RBAC | Cluster-wide read-only access to namespaces, Deployments, StatefulSets, DaemonSets and CronJobs (no pods or Secrets); update access only to the existing `info-output` ConfigMap in the `info` namespace. The collector runs as a non-root user with a read-only root filesystem. |

## Output

`info.json`:

```json
{
  "environment": "collab", "cluster": "collab", "generatedAt": "2026-10-15T02:00:00Z",
  "namespaces": ["..."],
  "workloads": [{
    "namespace": "websub", "kind": "Deployment", "name": "websub", "helmChart": "websub-1.3.0",
    "labels": {"...": "..."},
    "containers": [{"name": "websub", "image": "docker.io/mosipid/websub-service:1.3.0", "init": false}],
    "images": ["docker.io/mosipid/websub-service:1.3.0"], "initImages": ["docker.io/mosipdev/alpine:latest"],
    "desired": 1, "ready": 1, "schedule": null, "suspend": false, "lastSchedule": null
  }]
}
```

`info.txt` has one line per workload, app images first and init-container images after `Init:`, with a UTC timestamp at the end:

```text
Namespace: websub
----------------
Deployment: websub, Image: docker.io/mosipid/websub-service:1.3.0, Init: docker.io/mosipdev/alpine:latest

Script executed at 2026-10-15T02:00:00Z
```

Compared with the older Helm chart's text, there are no `Helm Chart Version:`, `Job:` or `ImageID:` lines (the chart version is in `info.json`), and multi-container workloads are on one line.

## Install

```sh
[SETTING=value ...] ./install.sh [kubeconfig]
```

| Setting | Default | Meaning |
| --- | --- | --- |
| `ENV_NAME` | prompted; suggests the current kube context name | Name shown on the dashboard and written to `info.json`. |
| `CLUSTER_NAME` | current kube context name, else `ENV_NAME` | Cluster name written to `info.json`. |
| `SCHEDULE` | `0 2 * * *` | Cron schedule, in cluster time (normally UTC). |
| `GATEWAY` | `istio-system/internal` | Istio gateway(s) serving `/info`, comma separated. The report is a full map of workloads and image tags, so only set `istio-system/public` deliberately. |
| `KUBECTL_IMAGE` | newest `alpine/k8s` tag for the cluster's Kubernetes minor version | Collector image; needs `kubectl`, `jq` and `sh`. Set it when Docker Hub is unreachable from where you run `install.sh`. |
| `EXCLUDED_NAMESPACE` | `^(istio\|cattle\|kube\|info)` | Regex of namespaces left out of the report. |
| `DRY_RUN` | unset | `1` prints the rendered manifests instead of applying them. |

Examples:

```sh
./install.sh ~/.kube/collab.yaml                       # prompts for the environment name
ENV_NAME=released ./install.sh ~/.kube/released.yaml
ENV_NAME=synergy SCHEDULE="30 3 * * 1-5" ./install.sh ~/.kube/synergy.yaml
ENV_NAME=qa DRY_RUN=1 ./install.sh                     # review before applying
```

The script creates the `info` namespace with Istio injection, removes the old `info` Helm release if present (after confirmation), creates the empty `info-output` ConfigMap, applies the manifests and runs the collector once. Re-run it with new settings to change them.

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
