# qajava21 dev testrig deployment

Deploy **packetcreator** and **dslrig** (dslorchestrator) on the **qajava21** environment with the **dev** space in the `default` namespace global configmap.

## Prerequisites

* qajava21 Kubernetes cluster is provisioned and accessible via kubeconfig (e.g. `qajava21.config`)
* MOSIP external and core services are already running (postgres, keycloak, minio, config-server, artifactory, etc.)
* `kubectl`, `helm`, and `jq` are installed locally
* Helm repo is available: `helm repo add mosip https://mosip.github.io/mosip-helm`

## What this script does

1. Applies `deployment/v3/external/global_configmap.qajava21-dev.yaml` to the **default** namespace with:
   * `installation-name: dev`
   * `installation-domain: qajava21.mosip.net`
2. Installs **packetcreator** in the `packetcreator` namespace (reads `mosip-api-internal-host` from `default/global`)
3. Installs **dslorchestrator** in the `dslrig` namespace (copies `global` and other configmaps from `default` and peer namespaces)

## Install

```sh
cd deployment/v3/testrig/qajava21-dev
chmod +x install.sh
./install.sh /path/to/qajava21.config
```

## Optional environment variables

| Variable | Default | Description |
|---|---|---|
| `CHART_VERSION` | `1.4.0` | Helm chart version for packetcreator and dslorchestrator |
| `CRON_HOUR` | `4` | Daily cron hour (0-23) for dslorchestrator |
| `REPORT_RETENTION_DAYS` | `3` | Report retention for dslorchestrator |
| `PACKET_UTILITY_BASE_URL` | `http://packetcreator.packetcreator:80/v1/packetcreator` | Packetcreator service URL |
| `ENABLE_INSECURE` | `true` | Use self-signed SSL init-container (`true`/`false`) |

Example:

```sh
CHART_VERSION=1.4.0 CRON_HOUR=2 ./install.sh ~/qajava21.config
```

## Helmsman / mosip-infra rapid deployment (alternative)

If the cluster was created with [mosip/infra](https://github.com/mosip/infra) on branch `qajava21`, run the GitHub Actions workflow **Deploy Testrigs of mosip using Helmsman** with:

* **Branch**: `qajava21`
* **Profile**: `mosip-platform-java21`
* **Mode**: `apply`
* **domain_name**: `qajava21.mosip.net`
* **env_name**: `dev`

Ensure the GitHub environment `qajava21` has `DOMAIN_NAME`, `ENV_NAME=dev`, and `SLACK_CHANNEL_NAME` variables configured.

## Verify

```sh
kubectl --kubeconfig=/path/to/qajava21.config -n default get cm global
kubectl --kubeconfig=/path/to/qajava21.config -n packetcreator get pods
kubectl --kubeconfig=/path/to/qajava21.config -n dslrig get pods,cronjob
```

## Uninstall

```sh
cd deployment/v3/testrig/packetcreator && ./delete.sh /path/to/qajava21.config
cd ../dslrig && ./delete.sh /path/to/qajava21.config
```
