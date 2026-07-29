# Idrepo API TestRig → idrepo1230 (v1.2.3.0)

Point the **idrepo-only** API TestRig at the parallel `idrepo1230` stack, using image tag **`mosipid/apitest-idrepo:1.2.3.0`**.

## Why not change ENV_ENDPOINT?

Apitestrig still needs Keycloak / authmanager / masterdata / etc. on the shared env.
Keep:

`ENV_ENDPOINT=https://api-internal.qa11new.mosip.net`

Only **retarget Istio VirtualService destinations** for idrepo path prefixes so those paths hit `idrepo1230` services. No new Gateway is required.

| Path prefix | Target service |
|---|---|
| `/idrepository/v1/identity` | `identity1230.idrepo1230` |
| `/v1/credentialservice` | `credential1230.idrepo1230` |
| `/v1/credentialrequest` | `credentialrequest1230.idrepo1230` |
| `/idrepository/v1` (vid) | `vid1230.idrepo1230` |

## Prerequisites

1. `idrepo1230` pods are Running (identity / credential / credentialrequest / vid).
2. Run apitestrig prereq once (config-server audience overrides), if not already done:
   ```sh
   cd ../apitestrig
   ./prereq.sh
   ```

## Install steps

```sh
cd deployment/v3/testrig/apitestrig-idrepo1230
chmod +x *.sh

# 1) Point api-internal idrepo routes at idrepo1230 (backs up VS YAML under ./vs-backup/)
./retarget-vs.sh

# Optional: avoid duplicate routes if idrepo1230 also has VS with the same prefixes
# kubectl -n idrepo1230 get virtualservice
# kubectl -n idrepo1230 delete virtualservice --all

# 2) Install idrepo-only apitestrig (tag 1.2.3.0)
./install.sh
```

During `install.sh` prompts:
- Cron hour (0–23)
- Public domain / valid SSL? Use `n` for typical QA self-signed setups
- Report retention days (default 3)
- Slack webhook URL
- eSignet deployed? (`yes`/`no`)

## Run manually

```sh
kubectl -n apitestrig get cronjob | grep idrepo

kubectl -n apitestrig create job --from=cronjob/cronjob-idrepo-apitestrig-idrepo \
  idrepo-apitestrig-manual-$(date +%s)
```

CronJob name can vary slightly by chart version; confirm with `kubectl -n apitestrig get cronjob`.

## Verify routes before running tests

```sh
API=$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}')
curl -sk "https://$API/idrepository/v1/identity/actuator/health"
curl -sk "https://$API/v1/credentialservice/actuator/health"
curl -sk "https://$API/v1/credentialrequest/actuator/health"
curl -sk "https://$API/idrepository/v1/vid/actuator/health"
```

## Restore original idrepo routes

```sh
# If backups exist:
kubectl -n idrepo apply -f ./vs-backup/
```

## Uninstall testrig only

```sh
./delete.sh
```

This does **not** restore VirtualServices; apply `./vs-backup/` separately if needed.
