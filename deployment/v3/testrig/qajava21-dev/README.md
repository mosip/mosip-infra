# qajava21 testrig in namespace `dev`

Deploy **packetcreator** and **dslorchestrator** on **qajava21** into a **new Kubernetes namespace `dev`**, not into the usual `packetcreator` / `dslrig` namespaces.

## Namespace layout

| Namespace | Role |
|---|---|
| `default` | Source of truth — existing `global` configmap is **not modified** |
| `dev` | New namespace — both packetcreator and dslorchestrator run here |

The installer copies `global` from `default` → `dev` and sets `installation-name: dev` **only** on `dev/global`.

## Prerequisites

* qajava21 cluster kubeconfig (e.g. `qajava21.config`)
* `configmap/global` already present in `default` (from MOSIP prereq / Helmsman)
* MOSIP stack running (postgres, keycloak, minio, config-server, artifactory, …)
* `kubectl`, `helm`, `jq`

## Install

```sh
cd deployment/v3/testrig/qajava21-dev
./install.sh /path/to/qajava21.config
```

Use a different namespace name:

```sh
TARGET_NS=dev ./install.sh /path/to/qajava21.config
```

## Optional environment variables

| Variable | Default | Description |
|---|---|---|
| `TARGET_NS` | `dev` | Namespace for both services |
| `INSTALLATION_NAME` | `dev` | Value written to `TARGET_NS/global` `installation-name` |
| `CHART_VERSION` | `1.4.0` | Helm chart version |
| `CRON_HOUR` | `4` | DSL cron hour (0–23) |
| `PACKET_UTILITY_BASE_URL` | `http://packetcreator.dev:80/v1/packetcreator` | In-cluster packetcreator URL (uses `TARGET_NS`) |
| `ENABLE_INSECURE` | `true` | Self-signed SSL init-container |

## Verify

```sh
kubectl --kubeconfig=/path/to/qajava21.config -n default get cm global
kubectl --kubeconfig=/path/to/qajava21.config -n dev get cm global
kubectl --kubeconfig=/path/to/qajava21.config -n dev get pods
kubectl --kubeconfig=/path/to/qajava21.config -n dev get cronjob
```

## Uninstall

```sh
helm --kubeconfig=/path/to/qajava21.config -n dev uninstall packetcreator dslorchestrator
kubectl --kubeconfig=/path/to/qajava21.config delete ns dev
```

## Helmsman note

Standard [mosip/infra](https://github.com/mosip/infra) `testrigs-dsf.yaml` still targets `packetcreator` and `dslrig` namespaces. This script is for an **additional** `dev` namespace deployment alongside or instead of those namespaces on the same cluster.
