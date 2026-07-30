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
2. In-cluster URL overrides mounted on **all four** deploys (`identity1230`, `vid1230`, `credential1230`, `credentialrequest1230`) so identity does not call default `http://credentialrequest.idrepo`. See [Troubleshooting](#troubleshooting-mosip_credential1230-stuck-at-1-row).
3. Run apitestrig prereq once (config-server audience overrides), if not already done:
   ```sh
   cd ../apitestrig
   ./prereq.sh
   ```

## Namespace

Installs into **`apitestrig1230` by default**, not the existing `apitestrig` namespace.

Do **not** reuse `apitestrig`: the install deletes/recreates shared configmaps (`s3`, `db`, `apitestrig`) and would break your current testrig. Helm release name is `idrepo-apitestrig`.

Override if needed: `NS=apitestrig1230 ./install.sh`

## Install steps

```sh
cd deployment/v3/testrig/apitestrig-idrepo1230
chmod +x *.sh

# 1) Point api-internal idrepo routes at idrepo1230 (backs up VS YAML under ./vs-backup/)
./retarget-vs.sh

# Optional: avoid duplicate routes if idrepo1230 also has VS with the same prefixes
# kubectl -n idrepo1230 get virtualservice
# kubectl -n idrepo1230 delete virtualservice --all

# 2) Install idrepo-only apitestrig (tag 1.2.3.0) into apitestrig1230
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
kubectl -n apitestrig1230 get cronjob | grep idrepo

kubectl -n apitestrig1230 create job --from=cronjob/cronjob-idrepo-apitestrig-idrepo \
  idrepo-apitestrig-manual-$(date +%s)
```

CronJob name can vary slightly by chart version; confirm with `kubectl -n apitestrig1230 get cronjob`.

## Verify routes before running tests

```sh
API=$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}')
curl -sk "https://$API/idrepository/v1/identity/actuator/health"
curl -sk "https://$API/v1/credentialservice/actuator/health"
curl -sk "https://$API/v1/credentialrequest/actuator/health"
curl -sk "https://$API/idrepository/v1/vid/actuator/health"
```

## Troubleshooting: `mosip_credential1230` stuck at 1 row

Gateway health hitting `credential1230` / `credentialrequest1230` is **not** enough.

Identity create/update writes UINs to `mosip_idrepo1230`, then a background job calls:

`mosip.idrepo.credrequest.generator.url` → `/v1/credentialrequest/requestgenerator`

Default from config-server is `http://credentialrequest.idrepo` (old namespace). That writes `credential_transaction` into **`mosip_credential`**, not `mosip_credential1230`.

Smoking gun from a parallel run:

| DB | Signal |
|---|---|
| `mosip_idrepo1230` UINs | grow during testrig |
| `mosip_credential` txns | `max(cr_dtimes)` moves at the same time |
| `mosip_credential1230` txns | stuck (e.g. 1 row from an earlier smoke) |

### Fix A — cache (current blocker on qa11new)

Identity logs show:

`Cannot find cache named 'Online_Verification_Partners'`

inside `CredentialServiceManager.notifyUinCredential`. That means credential issuance never calls credentialrequest, so `mosip_credential1230` stays stuck.

Cause: overrides set `spring.cache.type=simple` without cache names. Prefer Redis (remove the simple override). Quick workaround:

```bash
# Option 1 (preferred): stop forcing simple cache — use shared Redis like main idrepo
kubectl -n idrepo1230 get cm idrepo1230-overrides -o yaml \
  | sed '/SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_SPRING_CACHE_TYPE/d' \
  | kubectl apply -f -

# Option 2: keep simple, but declare cache names (also in patch-service-urls SPRING_APPLICATION_JSON)
kubectl -n idrepo1230 create configmap idrepo1230-cache \
  --from-literal=SPRING_CACHE_TYPE=simple \
  --from-literal=SPRING_CACHE_CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics' \
  --dry-run=client -o yaml | kubectl apply -f -
# mount idrepo1230-cache on identity1230 (and credential*) via extraEnvVarsCM, then:
kubectl -n idrepo1230 rollout restart deploy/identity1230
```

After restart, identity logs must stop repeating `Online_Verification_Partners`. Then re-check `mosip_credential1230`.

WebSub `Publisher is not authorized` is a separate issue (topic registration); the cache error is what blocks credential_transaction inserts.

### Fix B — REST URI

Mounting `SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_MOSIP_IDREPO_CREDREQUEST_GENERATOR_URL`
is **not enough**. Identity’s `RestRequestBuilder` uses the already-expanded property:

`mosip.idrepo.credential.request.rest.uri`
→ default `http://credentialrequest.idrepo/v1/credentialrequest/requestgenerator`

Override that URI (and related ones) via `SPRING_APPLICATION_JSON`:

```sh
./patch-service-urls.sh
# then run the helm upgrade commands it prints (identity/vid/credential/credentialrequest)
```

Verify the **effective** property (not just pod env):

```sh
API=$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}')
curl -sk "https://$API/idrepository/v1/identity/actuator/env" \
  | jq -r '.. | objects | to_entries[]? | select(.key=="mosip.idrepo.credential.request.rest.uri") | .value.value // .value'
# must contain credentialrequest1230 — not credentialrequest.idrepo
```

Also check identity-side status table:

```sql
\c mosip_idrepo1230
SELECT status, count(*), max(cr_dtimes)
FROM idrepo.credential_request_status
GROUP BY status;
```

Optional isolation smoke (writes straight into credentialrequest1230 DB if auth works):

```sh
# After obtaining a token as mosip-crereq-client / idrepo client, POST
# /v1/credentialrequest/requestgenerator — then:
#   SELECT count(*), max(cr_dtimes) FROM credential.credential_transaction;
# on mosip_credential1230
```

Re-run testrig / create one identity; `mosip_credential1230.credential_transaction` `max(cr_dtimes)` should advance.

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
