# DSLRIG in namespace `dsl-dev`

Deploys **dslorchestrator** into Kubernetes namespace **`dsl-dev`**, using the existing **packetcreator** release in **`packetcreator-dev`**.

## Layout

| Namespace | Component |
|---|---|
| `packetcreator-dev` | Existing packetcreator (already deployed) |
| `dsl-dev` | dslorchestrator (this installer) |
| `default` | Source `global` configmap (copied into `dsl-dev`, not modified) |

Default packet utility URL:

```text
http://packetcreator.packetcreator-dev:80/v1/packetcreator
```

## Prerequisites

* `packetcreator` is running in namespace `packetcreator-dev`
* Authdemo and dsl-dev run in the same cluster
* `default/global` configmap exists
* NFS / shared storage as required by your MOSIP testrig setup
* Helm repo: `helm repo add mosip https://mosip.github.io/mosip-helm`

## Install

```sh
cd deployment/v3/testrig/dsl-dev
chmod +x install.sh copy_cm.sh copy_secrets.sh delete.sh
./install.sh /path/to/kubeconfig
```

Prompts:

* Cron hour (0–23)
* Public domain / valid SSL (`Y` / `n`)
* Packet utility base URL (press Enter to use the `packetcreator-dev` default)
* Report retention days (default 3)
* DB port (default 5432)

Chart version: **1.5.0**

## Verify

```sh
kubectl -n dsl-dev get pods,cronjob
kubectl -n packetcreator-dev get pods
```

## Run manually

```sh
kubectl --kubeconfig=<kubeconfig> -n dsl-dev create job --from=cronjob/<cronjob-name> <job-name>
```

## Uninstall

```sh
./delete.sh /path/to/kubeconfig
```
