# Testrig in namespace `dev`

Deploy **packetcreator** and **dslorchestrator** into a **new Kubernetes namespace `dev`**, not into `packetcreator` / `dslrig`.

## Namespace layout

| Namespace | Role |
|---|---|
| `default` | Existing `global` configmap — **not modified** |
| `dev` | Both packetcreator and dslorchestrator |

`global` is copied from `default` → `dev`; `installation-name: dev` is set **only** on `dev/global`.

## Prerequisites

* Cluster kubeconfig (e.g. `dev.config` for `dev.mosip.net`)
* `default/global` configmap exists
* MOSIP prerequisites running
* `kubectl`, `helm`, `jq`

## Install

```sh
cd deployment/v3/testrig/dev
./install.sh /path/to/dev.config
```

## Optional environment variables

| Variable | Default | Description |
|---|---|---|
| `TARGET_NS` | `dev` | Namespace for both services |
| `INSTALLATION_NAME` | `dev` | `installation-name` on copied `global` in `TARGET_NS` |
| `CHART_VERSION` | `0.0.1-develop` | Helm chart version |
| `PACKET_UTILITY_BASE_URL` | `http://packetcreator.dev:80/v1/packetcreator` | Packetcreator service URL |
| `DB_PORT` | `5433` | Postgres port for dslorchestrator |

See `install.sh` for image repo/tag overrides aligned with mosip/infra `dev` branch testrigs DSF.

## Verify

```sh
kubectl --kubeconfig=/path/to/dev.config -n dev get pods,cronjob,cm global
```

## Uninstall

```sh
helm --kubeconfig=/path/to/dev.config -n dev uninstall packetcreator dslorchestrator
kubectl --kubeconfig=/path/to/dev.config delete ns dev
```
