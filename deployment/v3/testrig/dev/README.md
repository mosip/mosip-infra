# dev environment testrig deployment

Deploy **packetcreator** and **dslrig** (dslorchestrator) on the MOSIP **dev** environment (`dev.mosip.net`), with `installation-name: dev` in the `default` namespace global configmap.

## Prerequisites

* `dev` Kubernetes cluster is accessible via kubeconfig (e.g. `dev.config`)
* MOSIP external and core services are already running (postgres, keycloak, minio, config-server, artifactory, etc.)
* `kubectl`, `helm`, and `jq` are installed locally
* Helm repo: `helm repo add mosip https://mosip.github.io/mosip-helm`

## What this script does

1. Ensures `default/global` has `installation-name: dev` (patches existing configmap; applies full template only if missing)
2. Installs **packetcreator** in the `packetcreator` namespace
3. Installs **dslorchestrator** in the `dslrig` namespace (copies `global` and related configmaps/secrets from `default` and peer namespaces)

Chart/image defaults match [mosip/infra](https://github.com/mosip/infra) `dev` branch `Helmsman/dsf/testrigs-dsf.yaml`.

## Install

```sh
cd deployment/v3/testrig/dev
chmod +x install.sh
./install.sh /path/to/dev.config
```

## Optional environment variables

| Variable | Default | Description |
|---|---|---|
| `CHART_VERSION` | `0.0.1-develop` | Helm chart version |
| `PACKETCREATOR_IMAGE_REPO` | `mosipdev/dsl-packetcreator` | Packetcreator image repo |
| `PACKETCREATOR_IMAGE_TAG` | `develop` | Packetcreator image tag |
| `DSLORCHESTRATOR_IMAGE_REPO` | `mosipdev/dsl-orchestrator` | DSL image repo |
| `DSLORCHESTRATOR_IMAGE_TAG` | `develop` | DSL image tag |
| `CRON_HOUR` | `4` | Daily cron hour (0-23) |
| `REPORT_RETENTION_DAYS` | `3` | Report retention days |
| `PACKET_UTILITY_BASE_URL` | `http://packetcreator.packetcreator:80/v1/packetcreator` | Packetcreator URL |
| `ENABLE_INSECURE` | `true` | Self-signed SSL init-container |
| `DB_PORT` | `5433` | Postgres port used by dslrig |
| `THREAD_COUNT` | `2` | DSL parallel thread count |
| `ESIGNET_DEPLOYED` | `no` | Whether eSignet is deployed |
| `SERVICES_NOT_DEPLOYED` | `esignet` | Services to skip in DSL |

Example:

```sh
PACKETCREATOR_IMAGE_TAG=MOSIP-42917 DSLORCHESTRATOR_IMAGE_TAG=MOSIP-42917 ./install.sh ~/dev.config
```

## Helmsman / mosip-infra rapid deployment (alternative)

If the cluster was created with [mosip/infra](https://github.com/mosip/infra) on branch `dev`, run **Deploy Testrigs of mosip using Helmsman** with:

* **Branch**: `dev`
* **Mode**: `apply`
* **domain_name**: `dev.mosip.net`
* **env_name**: `dev`

## Verify

```sh
kubectl --kubeconfig=/path/to/dev.config -n default get cm global
kubectl --kubeconfig=/path/to/dev.config -n packetcreator get pods
kubectl --kubeconfig=/path/to/dev.config -n dslrig get pods,cronjob
```

## Uninstall

```sh
cd deployment/v3/testrig/packetcreator && ./delete.sh /path/to/dev.config
cd ../dslrig && ./delete.sh /path/to/dev.config
```
