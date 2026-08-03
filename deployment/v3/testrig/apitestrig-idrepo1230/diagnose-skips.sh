#!/bin/bash
# Summarize WHY idrepo apitestrig cases were skipped.
# Credential/cache wiring can be green while skips remain — this script
# extracts SkipException reasons from the latest (or named) job/pod logs.
#
# Usage:
#   ./diagnose-skips.sh
#   ./diagnose-skips.sh [kubeconfig]
#   POD=idrepo-apitestrig-manual-... ./diagnose-skips.sh
#   JOB=idrepo-apitestrig-manual-... ./diagnose-skips.sh
#
# Typical skip buckets (apitest-idrepo 1.2.3.0):
#   TARGET_ENV_HEALTH_CHECK_FAILED  → DOWN actuator on ENV_ENDPOINT (run ./check-health-deps.sh)
#   KNOWN_ISSUES                    → testCaseSkippedList.txt (always skipped upstream)
#   feature not supported           → DOB/Email/handle schema / admin not deployed
#   Service not deployed            → eSignet=no (or similar) at install
#   VID feature not supported       → identity actuator idTypes without VID

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi

NS=${NS:-apitestrig1230}
DEDICATED_HOST=${DEDICATED_HOST:-}
export LOG_FILE=${LOG_FILE:-/tmp/idrepo1230-apitestrig-skips.log}

set -euo pipefail

echo "=== A) apitestrig config (skip-related) ==="
if kubectl -n "$NS" get cm apitestrig >/dev/null 2>&1; then
  EP=$(kubectl -n "$NS" get cm apitestrig -o jsonpath='{.data.ENV_ENDPOINT}' 2>/dev/null || true)
  ES=$(kubectl -n "$NS" get cm apitestrig -o jsonpath='{.data.eSignetDeployed}' 2>/dev/null || true)
  LVL=$(kubectl -n "$NS" get cm apitestrig -o jsonpath='{.data.ENV_TESTLEVEL}' 2>/dev/null || true)
  echo "ENV_ENDPOINT=${EP:-?}"
  echo "eSignetDeployed=${ES:-?}"
  echo "ENV_TESTLEVEL=${LVL:-?}"
  if [ "${ES:-}" = "no" ]; then
    echo "INFO eSignetDeployed=no → esignet-tagged cases SKIP (expected)"
  fi
else
  echo "WARN configmap apitestrig not found in $NS"
fi

if kubectl -n "$NS" get cm db >/dev/null 2>&1; then
  DB_SERVER=$(kubectl -n "$NS" get cm db -o jsonpath='{.data.db-server}' 2>/dev/null || true)
  DB_PORT_CM=$(kubectl -n "$NS" get cm db -o jsonpath='{.data.db-port}' 2>/dev/null || true)
  echo "db-server=${DB_SERVER:-?} db-port=${DB_PORT_CM:-?}"
  case "${DB_SERVER:-}" in
    api-internal*|api-idrepo1230*)
      echo "WARN db-server looks like an HTTP API host, not Postgres — JDBC cleanup often fails."
      echo "     Reinstall with: DB_HOST=172.31.15.40 DB_PORT=5433 ENV_ENDPOINT=... ./install.sh"
      ;;
  esac
else
  echo "WARN configmap db not found in $NS"
fi
echo

echo "=== B) pick apitestrig pod ==="
POD=${POD:-}
if [ -z "$POD" ] && [ -n "${JOB:-}" ]; then
  POD=$(kubectl -n "$NS" get pods -l "job-name=$JOB" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
fi
if [ -z "$POD" ]; then
  # Prefer a completed/running job pod named like idrepo*apitestrig*
  POD=$(kubectl -n "$NS" get pods --sort-by=.metadata.creationTimestamp \
    -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null \
    | grep -E 'idrepo.*apitestrig|apitestrig.*idrepo|cronjob-idrepo' | tail -1 || true)
fi
if [ -z "$POD" ]; then
  echo "FAIL no apitestrig pod found in $NS"
  echo "  kubectl -n $NS get pods,jobs"
  echo "  Or: POD=<name> ./diagnose-skips.sh"
  exit 1
fi
echo "pod=$POD"
PHASE=$(kubectl -n "$NS" get pod "$POD" -o jsonpath='{.status.phase}' 2>/dev/null || echo "?")
echo "phase=$PHASE"
echo

echo "=== C) fetch logs → $LOG_FILE ==="
kubectl -n "$NS" logs "$POD" --tail=200000 >"$LOG_FILE" 2>/dev/null \
  || kubectl -n "$NS" logs "$POD" --all-containers --tail=200000 >"$LOG_FILE" 2>/dev/null \
  || true
LINES=$(wc -l <"$LOG_FILE" | tr -d ' ')
echo "log lines: $LINES"
if [ "$LINES" -lt 5 ]; then
  echo "FAIL empty/short logs — job may still be starting, or logs expired"
  exit 1
fi
echo

echo "=== D) run totals (if present) ==="
rg -n "Total tests run|Passes:|Failures:|Skips:|Application URI" "$LOG_FILE" | tail -20 || true
echo

echo "=== E) SkipException reason histogram ==="
# TestNG / framework usually logs the SkipException message
python3 - <<PY
import re, collections, os
path = os.environ.get("LOG_FILE", "/tmp/idrepo1230-apitestrig-skips.log")
text = open(path, errors="replace").read()

# Common skip message fragments from GlobalConstants / TestNG
patterns = [
    ("HEALTH_CHECK_FAILED", re.compile(r"TARGET_ENV_HEALTH_CHECK_FAILED|Target env health check failed|healthCheckFailure", re.I)),
    ("KNOWN_ISSUES", re.compile(r"KNOWN_ISSUES|known issue|testCaseSkippedList", re.I)),
    ("FEATURE_NOT_SUPPORTED", re.compile(r"feature not supported|FEATURE_NOT_SUPPORTED", re.I)),
    ("SERVICE_NOT_DEPLOYED", re.compile(r"Service not deployed|SERVICE_NOT_DEPLOYED", re.I)),
    ("VID_NOT_SUPPORTED", re.compile(r"VID feature not supported|VID_FEATURE_NOT_SUPPORTED", re.I)),
    ("HANDLE_SCHEMA", re.compile(r"HANDLE.*Schema|handle.*not.*deploy", re.I)),
    ("SKIP_GENERIC", re.compile(r"SkipException|skipping the test", re.I)),
]

counts = collections.Counter()
samples = collections.defaultdict(list)
for line in text.splitlines():
    for name, rx in patterns:
        if rx.search(line):
            counts[name] += 1
            if len(samples[name]) < 3:
                samples[name].append(line.strip()[:240])
            break

if not counts:
    print("No SkipException-style lines found in pod logs.")
    print("Check the HTML report in MinIO/S3 (s3 configmap) for per-case skip reasons.")
else:
    for name, n in counts.most_common():
        print(f"{n:5d}  {name}")
    print()
    print("--- samples ---")
    for name, _ in counts.most_common():
        print(f"[{name}]")
        for s in samples[name]:
            print(f"  {s}")
        print()

# Extract health failure map if present
m = re.search(r"healthCheckFailureMapS[^\n]*", text)
if not m:
    m = re.search(r"TARGET_ENV_HEALTH_CHECK_FAILED[^\n]*", text)
if m:
    print("--- health failure snippet ---")
    print(m.group(0)[:500])
PY
echo

echo "=== F) next actions ==="
echo "1) Health skips → refresh VS + curl deps:"
echo "     ./create-dedicated-host-vs.sh && ./check-health-deps.sh"
echo "2) eSignetDeployed=no → esignet skips are expected (answer yes at install only if eSignet is live)"
echo "3) KNOWN_ISSUES → upstream testCaseSkippedList.txt (~20 cases always skip)"
echo "4) FEATURE_NOT_SUPPORTED (DOB/Email/handle) → ID schema on this env; not a wiring bug"
echo "5) Full per-case reasons → TestNG HTML report in MinIO (s3-host from configmap s3)"
echo
echo "Credential path is independent — if mosip_credential1230 advanced, cache/REST wiring is OK."
