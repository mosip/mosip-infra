# Idrepo API TestRig → idrepo1230 (v1.2.3.0)

Point the **idrepo-only** API TestRig at the parallel `idrepo1230` stack, using image tag **`mosipid/apitest-idrepo:1.2.3.0`**.

## Why not change ENV_ENDPOINT?

Apitestrig still needs Keycloak / authmanager / masterdata / etc. on the shared env.
Keep:

`ENV_ENDPOINT=https://api-internal.qa11new.mosip.net`

Two routing options:

**A) Retarget shared `api-internal` paths** (default `./retarget-vs.sh`) — steals those prefixes from live `idrepo`.

**B) Dedicated host (recommended for isolation)** — keep live idrepo on `api-internal`, expose parallel stack on e.g. `api-idrepo1230.<env>.mosip.net`:

```bash
DEDICATED_HOST=api-idrepo1230.qa11new.mosip.net ./create-dedicated-host-vs.sh
# then DNS + Gateway host entry, and point apitestrig ENV_ENDPOINT at DEDICATED_HOST
```

| Path prefix | Target service |
|---|---|
| `/idrepository/v1/identity` | `identity1230.idrepo1230` |
| `/v1/credentialservice` | `credential1230.idrepo1230` |
| `/v1/credentialrequest` | `credentialrequest1230.idrepo1230` |
| `/idrepository/v1` (vid) | `vid1230.idrepo1230` |

In-cluster identity→credentialrequest must still use `*1230` service DNS (`./patch-service-urls.sh`); that is independent of the public host.

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

inside `CredentialServiceManager.notifyUinCredential` → no call to credentialrequest → `mosip_credential1230` stuck.

**Root cause (case mismatch):** qa11new `id-repository-dev.properties` has:

```properties
spring.cache.type=simple
mosip.idrepo.cache.names=...,online_verification_partners,...
spring.cache.cache-names=${mosip.idrepo.cache.names}
```

But Java `@Cacheable` uses `Online_Verification_Partners` (and `DATASHARE_POLICIES` / `PARTNER_EXTRACTOR_FORMATS`). With `simple`, `ConcurrentMapCacheManager` locks the configured names and rejects the Pascal/UPPER lookup. Redis (default profile) creates missing names at runtime, so this bug stays hidden there.

**Env / `JAVA_TOOL_OPTIONS` / `SPRING_APPLICATION_JSON` are not enough** — config-server still wins on qa11new (errors continue with count ~24/2m). A prior args-only patch also failed: `deploy/identity1230` kept an empty `command` and the stock image CMD.

```bash
git pull
./apply-cache-cmdline.sh
# Sets BOTH command=["/bin/bash","-lc"] and args=[java ... --spring.cache.cache-names=Online_Verification_Partners,...]
```

Verify (must show `/bin/bash` and `Online_Verification_Partners` on java):

```bash
kubectl -n idrepo1230 get deploy identity1230 \
  -o jsonpath='{.spec.template.spec.containers[0].command}{"\n"}'
kubectl -n idrepo1230 exec deploy/identity1230 -- \
  bash -lc 'ps -o args -A | grep "[j]ava.*identity"'
```

Re-run after any `helm upgrade` of `identity1230` (helm resets args).

**Do not set container `command`** — that replaces `./configure_start.sh` and causes CrashLoop (`BIO_SDK_007` / missing biosdk client). Only override `args` (CMD).

Permanent fix (preferred): in **mosip-config** branch `qa11new` `id-repository-dev.properties`:

```properties
mosip.idrepo.cache.names=credential_transaction,PARTNER_EXTRACTOR_FORMATS,DATASHARE_POLICIES,topics,Online_Verification_Partners,uin_encrypt_salt,uin_hash_salt,id_attributes
```

Then refresh config-server / restart identity1230 — no command patch needed.

Acceptance:

```bash
kubectl -n idrepo1230 logs deploy/identity1230 --since=2m \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'"
# expect 0

# should see PARTNERS_IDENTIFIED / requestgenerator traffic
kubectl -n idrepo1230 logs deploy/identity1230 --since=2m \
  | grep -E 'PARTNERS_IDENTIFIED|requestgenerator' | tail -20
```

Permanent fix in `mosip-config` (qa11new): set `mosip.idrepo.cache.names` to the exact `@Cacheable` names from id-repository 1.2.3.0.

WebSub `Publisher is not authorized` is a separate issue; the cache error is what blocks credential_transaction inserts.

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
