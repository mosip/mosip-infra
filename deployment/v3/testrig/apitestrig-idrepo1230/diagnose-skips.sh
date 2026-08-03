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
# Typical skip buckets (apitest-idrepo):
#   Target env health check failed  → DOWN actuator (run ./check-health-deps.sh)
#   known issue. Hence skipping...  → testCaseSkippedList.txt (always skipped)
#   feature not supported...        → DOB/Email/handle schema / admin not deployed
#   Service not deployed...         → eSignet=no (or similar) at install
#   VID feature not supported...    → identity actuator idTypes without VID

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi

NS=${NS:-apitestrig1230}
EXPECTED_IMAGE=${EXPECTED_IMAGE:-mosipid/apitest-idrepo:1.2.3.0}
EXPECTED_JAR=${EXPECTED_JAR:-apitest-idrepo-1.2.3.0}
export LOG_FILE=${LOG_FILE:-/tmp/idrepo1230-apitestrig-skips.log}

set -euo pipefail

# If you still see `rg: command not found`, you are on an old copy — git pull.
DIAG_VER=2026-08-03c
echo "diagnose-skips.sh $DIAG_VER (no ripgrep required)"
echo

grep_lines() {
  # portable: no ripgrep required
  grep -E "$@" 2>/dev/null || true
}

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

echo "=== B) pick apitestrig pod + image ==="
POD=${POD:-}
if [ -z "$POD" ] && [ -n "${JOB:-}" ]; then
  POD=$(kubectl -n "$NS" get pods -l "job-name=$JOB" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)
fi
if [ -z "$POD" ]; then
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

POD_IMAGE=$(kubectl -n "$NS" get pod "$POD" -o jsonpath='{range .spec.containers[*]}{.image}{"\n"}{end}' 2>/dev/null | grep -E 'apitest-idrepo|apitestrig' | head -1 || true)
if [ -z "$POD_IMAGE" ]; then
  POD_IMAGE=$(kubectl -n "$NS" get pod "$POD" -o jsonpath='{.spec.containers[0].image}' 2>/dev/null || true)
fi
echo "pod image: ${POD_IMAGE:-?}"

CRON_IMAGE=$(kubectl -n "$NS" get cronjob -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{range .spec.jobTemplate.spec.template.spec.containers[*]}{.image}{" "}{end}{"\n"}{end}' 2>/dev/null \
  | grep -E 'idrepo' | head -1 || true)
echo "cronjob:   ${CRON_IMAGE:-?(none)}"

if [ -n "$POD_IMAGE" ] && [ "$POD_IMAGE" != "$EXPECTED_IMAGE" ]; then
  echo "WARN pod image != expected $EXPECTED_IMAGE"
  echo "     Re-run: ENV_ENDPOINT=... DB_HOST=... DB_PORT=... ./install.sh"
  echo "     then create a new manual job (old Succeeded pods keep the old image)."
fi
echo

echo "=== C) fetch logs → $LOG_FILE ==="
# Prefer full logs; --tail alone can miss early totals on short runs
kubectl -n "$NS" logs "$POD" >"$LOG_FILE" 2>/dev/null \
  || kubectl -n "$NS" logs "$POD" --all-containers >"$LOG_FILE" 2>/dev/null \
  || true
LINES=$(wc -l <"$LOG_FILE" | tr -d ' ')
echo "log lines: $LINES"
if [ "$LINES" -lt 5 ]; then
  echo "FAIL empty/short logs — job may still be starting, or logs expired"
  exit 1
fi

JAR_HIT=$(grep -oE 'apitest-idrepo-[0-9.]+-jar-with-dependencies\.jar' "$LOG_FILE" | head -1 || true)
if [ -n "$JAR_HIT" ]; then
  echo "jar in logs: $JAR_HIT"
  case "$JAR_HIT" in
    ${EXPECTED_JAR}*) echo "OK jar matches expected $EXPECTED_JAR" ;;
    *)
      echo "WARN jar does not match expected $EXPECTED_JAR*"
      echo "     Image tag/chart may still be on an older apitest-idrepo build."
      ;;
  esac
fi
echo

echo "=== D) run totals / report paths (if present) ==="
grep_lines -n "Total tests run|Passes:|Failures:|Skips:|Application URI|Tests run:|Skipped:|Extent|emailable-report|push-reports|s3://|minio|Report|testng-results" "$LOG_FILE" | tail -40
echo
echo "--- log tail (last 40 lines; totals often land here) ---"
tail -n 40 "$LOG_FILE" | sed 's/^/  /'
echo

echo "=== E) SkipException reason histogram ==="
python3 - <<'PY'
import re, collections, os
path = os.environ.get("LOG_FILE", "/tmp/idrepo1230-apitestrig-skips.log")
text = open(path, errors="replace").read()
lines = text.splitlines()

# Exact-ish GlobalConstants messages (apitest-commons). Do NOT match
# "Copied ... testCaseSkippedList.txt" resource extraction noise.
patterns = [
    ("HEALTH_CHECK_FAILED", re.compile(r"Target env health check failed|TARGET_ENV_HEALTH_CHECK_FAILED|healthCheckFailureMapS", re.I)),
    ("KNOWN_ISSUES", re.compile(r"known issue\.?\s*Hence skipping the testcase", re.I)),
    ("FEATURE_NOT_SUPPORTED", re.compile(r"feature not supported\.?\s*Hence skipping the testcase", re.I)),
    ("SERVICE_NOT_DEPLOYED", re.compile(r"Service not deployed\.?\s*Hence skipping the testcase", re.I)),
    ("VID_NOT_SUPPORTED", re.compile(r"VID feature not supported", re.I)),
    ("UIN_NOT_SUPPORTED", re.compile(r"UIN feature not supported", re.I)),
    ("HANDLE_SCHEMA", re.compile(r"ARRAY HANDLE Related Schema|HANDLE_SCHEMA_NOT_DEPLOYED", re.I)),
    ("PRE_REQUISITE_FAILED", re.compile(r"pre requisite failed\.?\s*Hence skipping the testcase", re.I)),
    ("NOT_IN_RUN_SCOPE", re.compile(r"Not in run scope\.?\s*Hence skipping the testcase", re.I)),
    ("SKIP_GENERIC", re.compile(r"SkipException|Hence skipping the testcase", re.I)),
]

counts = collections.Counter()
samples = collections.defaultdict(list)
skipped_cases = []

case_skip_re = re.compile(
    r"(IdRepository_\S+).{0,80}?(known issue|feature not supported|Service not deployed|Target env health|VID feature not supported|pre requisite failed|Not in run scope|ARRAY HANDLE|skipping the testcase)",
    re.I,
)

for line in lines:
    # noise: resource copy of skip-list file
    if "testCaseSkippedList.txt" in line and "Copied the file" in line:
        continue
    if "resourceFile" in line and "testCaseSkippedList" in line:
        continue

    m = case_skip_re.search(line)
    if m:
        skipped_cases.append((m.group(1), m.group(2), line.strip()[:240]))

    for name, rx in patterns:
        if rx.search(line):
            counts[name] += 1
            if len(samples[name]) < 3:
                samples[name].append(line.strip()[:240])
            break

# TestNG-style suite summary
suite = re.findall(r"Tests run:\s*(\d+),\s*Failures:\s*(\d+),\s*Errors:\s*(\d+),\s*Skipped:\s*(\d+)", text)
if suite:
    print("--- TestNG suite summaries ---")
    for run, fail, err, skip in suite[-5:]:
        print(f"  Tests run={run} Failures={fail} Errors={err} Skipped={skip}")
    print()

mosip_tot = re.findall(r"Total tests run:\s*(\d+).*?Passes:\s*(\d+).*?Failures:\s*(\d+).*?Skips:\s*(\d+)", text, re.S | re.I)
# also single-line variants
mosip_line = re.findall(r"Total tests run:\s*(\d+)[^\n]*", text, re.I)
if mosip_line:
    print("--- MOSIP total lines ---")
    for s in mosip_line[-5:]:
        # reprint surrounding from original
        pass
    for line in lines:
        if re.search(r"Total tests run:", line, re.I):
            print(f"  {line.strip()[:240]}")
    print()

if not counts:
    print("No SkipException reason lines found in pod stdout.")
    print("Many builds only put per-case skip text in the HTML/Extent report (MinIO/S3),")
    print("not in container logs. Health deps are already covered by ./check-health-deps.sh.")
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

if skipped_cases:
    print(f"--- case-linked skip lines ({len(skipped_cases)}) ---")
    for case, reason, line in skipped_cases[:25]:
        print(f"  {case}  ({reason})")
    if len(skipped_cases) > 25:
        print(f"  ... {len(skipped_cases)-25} more")
    print()

m = re.search(r"Target env health check failed[^\n]*", text, re.I)
if m:
    print("--- health failure snippet ---")
    print(m.group(0)[:500])
    print()

# EmailableReport rename: ...full-report_T-N_P-N_S-N_F-N_I-N_KI-N.html
# S=skipped, F=failed, I=ignored (feature/service/schema gates), KI=known issues list
rep = re.search(
    r"full-report_T-(\d+)_P-(\d+)_S-(\d+)_F-(\d+)(?:_I-(\d+))?(?:_KI-(\d+))?\.html",
    text,
)
if rep:
    t, p, s, f = (int(rep.group(i)) for i in range(1, 5))
    ign = int(rep.group(5) or 0)
    ki = int(rep.group(6) or 0)
    print("--- EmailableReport breakdown (authoritative) ---")
    print(f"  Total={t}  Pass={p}  Fail={f}  Skip(S)={s}  Ignored(I)={ign}  KnownIssues(KI)={ki}")
    print(f"  TestNG 'Skips' line usually = S+I+KI = {s + ign + ki}")
    print()
    if f == 0 and s == 0:
        print("VERDICT: 0 failures, 0 hard skips.")
        print(f"  {ki} known-issue cases (upstream testCaseSkippedList) — expected")
        print(f"  {ign} ignored cases (feature/service/schema/not-in-scope) — env gates, not wiring")
        print("  Parallel idrepo1230 + dedicated apitestrig wiring looks SUCCESSFUL.")
    elif f > 0:
        print(f"VERDICT: {f} FAILURES — open the MinIO HTML report for case details.")
    else:
        print(f"VERDICT: S={s} hard skips remain — check health deps / report HTML.")
    print()
PY
echo

echo "=== F) interpretation ==="
echo "Report filename counters (from EmailableReport):"
echo "  S  = hard SkipException skips (e.g. health) — want 0"
echo "  I  = Ignored (feature not supported / service not deployed / schema / not in scope)"
echo "  KI = Known Issues (upstream testCaseSkippedList.txt) — expected ~20"
echo "  F  = Failures — want 0"
echo "TestNG 'Skips: N' = S + I + KI."
if kubectl -n "$NS" get cm s3 >/dev/null 2>&1; then
  S3_HOST=$(kubectl -n "$NS" get cm s3 -o jsonpath='{.data.s3-host}' 2>/dev/null || true)
  S3_USER=$(kubectl -n "$NS" get cm s3 -o jsonpath='{.data.s3-user-key}' 2>/dev/null || true)
  echo "MinIO: s3-host=${S3_HOST:-?} user=${S3_USER:-?} bucket=automation"
  echo "Report key hint: mosip-api-internal.qa11new-idrepo-*-full-report_T-*_P-*_S-*_F-*_I-*_KI-*.html"
fi
echo
echo "Credential path is independent — if mosip_credential1230 advanced, cache/REST wiring is OK."
