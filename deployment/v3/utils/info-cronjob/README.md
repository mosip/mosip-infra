# info-cronjob

A daily Kubernetes CronJob that collects every Deployment, StatefulSet, DaemonSet and CronJob in the cluster with its container images and ready status, and publishes the result at `https://<public-api-host>/info`:

* Browsers get an interactive dashboard (search, filters, health per namespace, image/version drift view, CSV export).
* `curl` and scripts get the plain-text report, in the same format as the older [info](../info) Helm chart.
* Raw data is at `/info/info.json` and `/info/info.txt`.

This replaces the `info` Helm chart (an nginx + `crond` pod that reserved ~3 GiB of memory). Tracked in [#1965](https://github.com/mosip/mosip-infra/issues/1965).

## How it works

| Component | Purpose |
| --- | --- |
| CronJob `info` | Runs [`base/fetch-info.sh`](base/fetch-info.sh) daily at 02:00 UTC in `alpine/k8s` and writes `info.json` + `info.txt` into ConfigMap `info-output`. |
| Deployment `info` | `nginx` serving [`base/index.html`](base/index.html) and the `info-output` ConfigMap. [`base/nginx.conf`](base/nginx.conf) returns HTML or text at `/info` based on the `Accept` header. |
| VirtualService `info` | Routes `/info` and `/info/*` on the `istio-system/public` gateway. |
| ServiceAccount / RBAC | Cluster-wide read-only access to namespaces and workloads; write access only to the `info-output` ConfigMap in the `info` namespace. |

Namespaces matching `^(istio|cattle|kube|info)` are excluded from the report.

## Layout

```
base/                 shared manifests, collector script, dashboard and nginx config
overlays/collab/      collab environment
overlays/released/    released environment
```

Each overlay sets the environment name (`ENV_NAME`), which is written to `info.json` and shown on the dashboard. To add an environment, copy an overlay directory and change `ENV_NAME`.

## Install

```sh
./install.sh <environment> [kubeconfig]
# e.g.
./install.sh collab ~/.kube/collab.yaml
```

The script creates the `info` namespace with Istio injection, removes the old `info` Helm release if present (after confirmation), applies the overlay and runs the collector once.

## Run the collector on demand

```sh
kubectl -n info create job --from=cronjob/info info-manual-$(date +%s)
```

The dashboard picks up the new data within about a minute; nginx does not need a restart.

## Configuration

| What | Where |
| --- | --- |
| Schedule | `spec.schedule` in the overlay patch (cluster time, normally UTC). |
| Excluded namespaces | `EXCLUDED_NAMESPACE` in `base/fetch-info.sh`. |
| Dashboard | `base/index.html`; re-apply the overlay and it is served within a minute. |
| nginx routing | `base/nginx.conf`; re-apply, then `kubectl -n info rollout restart deploy/info`. |

## Uninstall

```sh
./delete.sh <environment> [kubeconfig]
```
