# UITESTRIG on MOSIP `dev` (`*.dev.mosip.net`)

Non-interactive installer for **uitestrig** against the MOSIP **dev** environment.

Defaults match [mosip/infra](https://github.com/mosip/infra) Helmsman DSF on branch `dev`:

| Setting | Default |
|---|---|
| Domain | `dev.mosip.net` |
| Env name | `dev` |
| Chart | `mosip/uitestrig` `1.6.0` (override with `CHART_VERSION=12.0.2` for older Helmsman) |
| Cron hour | `3` (daily `0 3 * * *`) |
| DB port | `5433` |
| API | `https://api-internal.dev.mosip.net` |

## Prerequisites

* Kubeconfig for the **dev** cluster (download from Rancher), e.g. `~/dev.config`
* MOSIP stack already running (postgres, keycloak, minio, config-server, artifactory, portals)
* `kubectl`, `helm`, and `jq` installed locally
* Helm repo: `helm repo add mosip https://mosip.github.io/mosip-helm`

## Install (this repo)

```sh
cd deployment/v3/testrig/uitestrig-dev
chmod +x install.sh
./install.sh /path/to/dev.config
```

### Optional environment variables

| Variable | Default | Description |
|---|---|---|
| `DOMAIN_NAME` | `dev.mosip.net` | Environment domain |
| `ENV_NAME` | `dev` | Short env name used in `ENV_USER` |
| `CHART_VERSION` | `1.6.0` | Helm chart version (`mosipdev/uitest-pmp-v2` needs 1.6.x module names) |
| `ENV_TESTLEVEL` | `smokeAndRegression` | TestNG test level (was `null` in failing runs) |
| `CRON_HOUR` | `3` | Daily cron hour (0–23) |
| `DB_PORT` | `5433` | Postgres port |
| `ENABLE_INSECURE` | `false` | `true` for self-signed SSL |
| `USE_LOCAL_VALUES` | `true` | Apply local `values.yaml` module images |
| `TEST_URL` | _(empty)_ | Optional UI test URL (chart 1.6.x) |
| `BROWSERSTACK_USERNAME` / `BROWSERSTACK_ACCESS_KEY` | _(empty)_ | Optional BrowserStack creds |
| `MOSIP_INJIWEB_GOOGLE_*` | _(empty)_ | Optional Inji Web Google OAuth creds |

Example with release chart and insecure SSL:

```sh
CHART_VERSION=1.6.0 ENABLE_INSECURE=true USE_LOCAL_VALUES=false \
  ./install.sh ~/dev.config
```

## Install via Helmsman (mosip/infra) — preferred for the live cluster

In [mosip/infra](https://github.com/mosip/infra), run workflow **Deploy Testrigs of mosip using Helmsman** on branch **`dev`**:

* **Branch**: `dev`
* **Mode**: `apply`

This uses GitHub environment `dev` secrets (`KUBECONFIG`, WireGuard) and `Helmsman/dsf/testrigs-dsf.yaml` (uitestrig enabled, chart `12.0.2`, hosts under `*.dev.mosip.net`).

```sh
gh workflow run "Deploy Testrigs of mosip using Helmsman" \
  --repo mosip/infra \
  --ref dev \
  -f mode=apply
```

## Verify

```sh
kubectl --kubeconfig=/path/to/dev.config -n uitestrig get cronjob,pods
kubectl --kubeconfig=/path/to/dev.config -n uitestrig get cm uitestrig -o yaml
```

## Run manually

```sh
kubectl --kubeconfig=/path/to/dev.config -n uitestrig \
  create job --from=cronjob/cronjob-uitestrig cronjob-uitestrig-$(date +%Y%m%d%H%M%S)
```

## Uninstall

```sh
cd ../uitestrig
./delete.sh /path/to/dev.config
```
