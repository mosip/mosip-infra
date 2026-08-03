# Idrepo API TestRig → idrepo1230 (v1.2.3.0)

Point the **idrepo-only** API TestRig at the parallel `idrepo1230` stack, using image tag **`mosipid/apitest-idrepo:1.2.3.0`**.

## Routing options

**A) Retarget shared `api-internal` paths** (default `./retarget-vs.sh`) — steals those prefixes from live `idrepo`. Keep:

`ENV_ENDPOINT=https://api-internal.qa11new.mosip.net`

**B) Dedicated host (isolation)** — keep live idrepo on `api-internal`, expose parallel stack on `api-idrepo1230.<env>.mosip.net`.

**DNS is mandatory** for B. Without it apitestrig fails with:

`java.net.UnknownHostException: api-idrepo1230.qa11new.mosip.net`

```bash
./create-dedicated-host-vs.sh          # VS (idrepo1230 + shared authmanager/etc proxies)
./print-dns-hint.sh                    # find LB IP / CoreDNS hint
# create DNS A/CNAME OR CoreDNS hosts entry for api-idrepo1230 → same IP as api-internal
./ensure-dedicated-gateway-host.sh
curl -sk https://api-idrepo1230.qa11new.mosip.net/idrepository/v1/identity/actuator/health
ENV_ENDPOINT=https://api-idrepo1230.qa11new.mosip.net ./install.sh
```

Keycloak still comes from the copied `keycloak-host` configmap. Authmanager/masterdata/etc. are proxied on the dedicated VS to live services so one `ENV_ENDPOINT` works.

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

## Interpreting a completed run

A healthy dedicated-host run looks like:

```text
Application URI ======https://api-idrepo1230.qa11new.mosip.net
Total tests run: 414, Passes: 316, Failures: 0, Skips: 98
...full-report_T-414_P-316_S-0_F-0_I-78_KI-20.html
```

That report name means: **0 failures**, **0 hard skips (S)**, **78 ignored (I)**
(feature/schema/service gates), **20 known issues (KI)**. TestNG `Skips: 98` = I+KI.
This is a successful parallel-stack result — not a wiring failure.
Credential path OK (after cache fix) means `mosip_credential1230` rows move during the run
(e.g. `count=23`, `max(cr_dtimes)` same day as the run). **Skips are a separate issue** —
green credential DB does not imply zero skips.

### What causes skips

From `apitest-idrepo` 1.2.3.0:

| Bucket | When | Action |
|---|---|---|
| `TARGET_ENV_HEALTH_CHECK_FAILED` | Any **DOWN** idrepo-tagged actuator on `ENV_ENDPOINT` | `./check-health-deps.sh` |
| `KNOWN_ISSUES` | Case listed in upstream `testCaseSkippedList.txt` (~20) | Expected — ignore |
| `feature not supported` | DOB/Email/handle not in ID schema; Invalid_BioVal without admin | Schema/env — not wiring |
| `Service not deployed` | `eSignetDeployed=no` at install | Expected unless eSignet is live |
| `VID feature not supported` | Actuator idTypes without VID | Check identity/vid config |

Health paths that commonly FAIL on the dedicated host (must be proxied by VS):

| Path | Typical dest |
|---|---|
| `/biosdk-service/actuator/health` | biosdk |
| `/hub/actuator/health` | websub |
| `/v1/datashare/actuator/health` | datashare |
| `/v1/notifier/actuator/health` | notifier |
| `/v1/idgenerator/actuator/health` | idgenerator |
| `/v1/partnermanager/actuator/health` | pms-partner |

```bash
# 1) refresh dedicated VS proxies (includes idgenerator + partnermanager)
./create-dedicated-host-vs.sh

# 2) curl every idrepo health dep on the dedicated host
./check-health-deps.sh

# 3) after a testrig run — image/jar + SkipException histogram from pod logs
./diagnose-skips.sh

# 4) if logs show JDBC errors to api-internal:5432, or jar is still 1.2.2.x:
DB_HOST=172.31.15.40 DB_PORT=5433 \
  ENV_ENDPOINT=https://api-idrepo1230.qa11new.mosip.net ./install.sh
# then create a NEW manual job (Succeeded pods keep the old image/jar)
```

If `./check-health-deps.sh` is **14 OK / 0 FAIL** and config has `eSignetDeployed=yes` +
real Postgres, remaining skips are mostly upstream known-issues / schema feature gates.
Confirm the run used **`mosipid/apitest-idrepo:1.2.3.0`** (not a `1.2.2.4` jar).

Confirm credential path still hits the parallel DB:

```sql
-- mosip_credential1230
SELECT count(*), max(cr_dtimes) FROM credential.credential_transaction;
```

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

**Root cause:** qa11new config has lowercase `online_verification_partners` while v1.2.3.0 uses
`@Cacheable("Online_Verification_Partners")`. Config-server remote properties beat local
`-D` / `--` / `SPRING_APPLICATION_JSON` (actuator shows both `spring.cache.type=none` and `=simple`).

**Fix:** `./apply-cache-cmdline.sh` installs `lib/idrepo1230-cache-force.jar` on `loader.path` and
registers `CacheForceInitializer` via `-Dcontext.initializer.classes=...`. The initializer runs
**after** config-server bootstrap, `addFirst`s overrides, and replaces `cacheManager` with a
**dynamic** `ConcurrentMapCacheManager` (any cache name resolves).

```bash
git pull
./apply-cache-cmdline.sh
# logs must contain: idrepo1230CacheForce: property source installed
./diagnose-credential-path.sh
```

Re-run after any `helm upgrade` of `identity1230` (helm resets args).

**Do not set container `command`** — that replaces `./configure_start.sh` and causes CrashLoop (`BIO_SDK_007`). Only override `args` (CMD).

Permanent fix (preferred): in **mosip-config** `qa11new` `id-repository-dev.properties`, set
`spring.cache.cache-names` / `mosip.idrepo.cache.names` to the exact `@Cacheable` strings for the
image you run, **or** set `spring.cloud.config.allowOverride=true` + `overrideNone=true` remotely
so local overrides work without the jar.

Acceptance:

```bash
kubectl -n idrepo1230 logs deploy/identity1230 --since=2m \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'"
# expect 0

kubectl -n idrepo1230 logs deploy/identity1230 --since=2m \
  | grep -E 'idrepo1230CacheForce|PARTNERS_IDENTIFIED|requestgenerator' | tail -20
```

WebSub `Publisher is not authorized` is a separate issue; the cache error is what blocks credential_transaction inserts.

### Fix B — REST URI (required even when apitestrig “passes”)

Apitestrig AddIdentity can pass while `mosip_credential1230` stays at 1 row.
Identity’s background job must call `credentialrequest1230`; default config still
points at `http://credentialrequest.idrepo` → writes go to **`mosip_credential`**.

```sh
./apply-cache-cmdline.sh     # cache errors block notify entirely
./patch-service-urls.sh      # APPLIES SPRING_APPLICATION_JSON to the 4 deploys
./diagnose-credential-path.sh
```

Smoking gun SQL after one new identity create:

```sql
\c mosip_credential1230
SELECT count(*), max(cr_dtimes) FROM credential.credential_transaction;  -- must move

\c mosip_credential
SELECT count(*), max(cr_dtimes) FROM credential.credential_transaction;  -- if THIS moves, still on old NS
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
