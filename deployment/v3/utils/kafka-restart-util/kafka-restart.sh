#!/usr/bin/env bash
#
# kafka-restart.sh
# Sequentially restarts Kafka and its dependent modules.
# Designed to NEVER abort on timeouts or individual failures — it logs a
# warning and moves on to the next step.
#
# Usage:
#   ./kafka-restart.sh              # default 300s wait per rollout
#   TIMEOUT=600s ./kafka-restart.sh # custom wait time
#

set -u   # intentionally NOT using -e, so a failed step never kills the script

TIMEOUT="${TIMEOUT:-300s}"

WARNINGS=()

# Original replica count of every websub deployment, captured before the
# scale-down so the scale-up restores what was actually there (an HA install
# may run more than one replica).
declare -A WEBSUB_REPLICAS=()

# Print a timestamped progress line.
log()  { echo -e "\n==> [$(date '+%H:%M:%S')] $*"; }

# Record a non-fatal problem and carry on. Every warning is reprinted in the
# summary at the end of the run.
warn() {
  echo -e "!!  [$(date '+%H:%M:%S')] WARNING: $* — continuing anyway"
  WARNINGS+=("$*")
}

# Abort the run. Only used for pre-flight failures, before any cluster state
# has been touched, so it is always safe to simply re-run the script.
fatal() {
  echo -e "\n!!  [$(date '+%H:%M:%S')] FATAL: $*"
  echo "    Nothing has been modified — no service was scaled down or restarted."
  exit 1
}

# Wait for one rollout; warn (don't fail) on timeout
wait_rollout() {
  local ns="$1" kind="$2" name="$3"
  log "Waiting for ${kind}/${name} in ns=${ns} (timeout ${TIMEOUT})"
  kubectl rollout status "${kind}/${name}" -n "${ns}" --timeout="${TIMEOUT}" \
    || warn "TIMEOUT: ${kind}/${name} in ns=${ns} did not become ready within ${TIMEOUT}"
}

# Restart + wait for every object of a kind in a namespace
restart_all_and_wait() {
  local ns="$1" kind="$2"
  log "Restarting all ${kind}s in ns=${ns}"
  kubectl rollout restart -n "${ns}" "${kind}" || warn "restart of ${kind}s in ${ns} failed"
  local name
  for name in $(kubectl get "${kind}" -n "${ns}" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null); do
    wait_rollout "${ns}" "${kind}" "${name}"
  done
}

# Restart + wait for a single named object
restart_one_and_wait() {
  local ns="$1" kind="$2" name="$3"
  log "Restarting ${kind}/${name} in ns=${ns}"
  kubectl rollout restart -n "${ns}" "${kind}" "${name}" || warn "restart of ${kind}/${name} failed"
  wait_rollout "${ns}" "${kind}" "${name}"
}

# Scale a deployment back to the exact replica count recorded before the
# scale-down. A deployment that was already at 0 is left down: restoring it to
# 1 would change cluster state the operator did not ask us to change.
scale_up_and_wait() {
  local ns="$1" name="$2"
  local reps="${WEBSUB_REPLICAS[${name}]:-}"
  if ! [[ "${reps}" =~ ^[0-9]+$ ]]; then
    warn "no recorded replica count for ${name} in ns=${ns} — leaving it scaled down"
    return
  fi
  if [ "${reps}" -eq 0 ]; then
    log "${name} in ns=${ns} was at 0 replicas before the restart — leaving it down"
    return
  fi
  log "Scaling ${name} back to ${reps} replica(s) in ns=${ns}"
  kubectl scale deployment "${name}" --replicas="${reps}" -n "${ns}" \
    || warn "scale-up of ${name} to ${reps} failed"
  wait_rollout "${ns}" deployment "${name}"
}

##############################################################################
# 1. Scale down websub (protects its PVC during the Kafka restart)
##############################################################################
# Record what is running before anything is scaled down. This is a hard
# pre-condition: scaling websub to zero without a record of what to restore
# would strand deployments at zero replicas with no way to recover them, so a
# failure here aborts the run rather than proceeding on a guess.
log "Recording current websub replica counts"
if ! websub_rows="$(kubectl get deployment -n websub \
      -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.spec.replicas}{"\n"}{end}')"; then
  fatal "could not read websub deployment replica counts in ns=websub. Check cluster connectivity, the current kubectl context and RBAC, then re-run."
fi

while read -r _name _reps; do
  [ -n "${_name}" ] || continue
  WEBSUB_REPLICAS["${_name}"]="${_reps}"
  echo "    ${_name} = ${_reps}"
done <<< "${websub_rows}"

if [ ${#WEBSUB_REPLICAS[@]} -eq 0 ]; then
  fatal "no deployments found in ns=websub. Confirm you are pointed at the right cluster: kubectl config current-context"
fi

log "Scaling down all websub deployments to 0"
kubectl scale deployment --all --replicas=0 -n websub || warn "websub scale-down failed"

log "Waiting for websub pods to terminate"
kubectl wait --for=delete pod --all -n websub --timeout="${TIMEOUT}" \
  || warn "some websub pods still terminating after ${TIMEOUT}"

##############################################################################
# 2. Restart Kafka + Zookeeper statefulsets and kafka-ui simultaneously
##############################################################################
log "Restarting kafka statefulsets (kafka + zookeeper) and kafka-ui together"
kubectl rollout restart -n kafka statefulset || warn "restart of kafka statefulsets failed"
kubectl rollout restart -n kafka deployment kafka-ui || warn "restart of kafka-ui failed"

# Now wait for all of them to come back
for name in $(kubectl get statefulset -n kafka -o jsonpath='{.items[*].metadata.name}' 2>/dev/null); do
  wait_rollout kafka statefulset "${name}"
done
wait_rollout kafka deployment kafka-ui

##############################################################################
# 3. Bring websub back up (consolidator first, then websub, then any others)
##############################################################################
# Consolidator first, then websub, then anything else that was recorded.
for name in websub-consolidator websub; do
  [ -n "${WEBSUB_REPLICAS[${name}]:-}" ] && scale_up_and_wait websub "${name}"
done

for name in "${!WEBSUB_REPLICAS[@]}"; do
  case "${name}" in
    websub|websub-consolidator) continue ;;
  esac
  scale_up_and_wait websub "${name}"
done

##############################################################################
# 4. Kernel services
##############################################################################
restart_one_and_wait kernel deployment syncdata
restart_one_and_wait kernel deployment masterdata

##############################################################################
# 5. IDA namespace (sequential — completes before the parallel batch below)
##############################################################################
restart_all_and_wait ida deployment   # no name means ALL deployments in ns

##############################################################################
# 6. Everything after IDA — restarted SIMULTANEOUSLY
#    (idrepo, pms, resident, print, digitalcard,
#     regproc-notifier, regproc-workflow, regproc-reprocess)
##############################################################################
log "Triggering simultaneous restart of idrepo, pms, resident, print, digitalcard, regproc services"
kubectl rollout restart -n idrepo deployment || warn "restart of idrepo deployments failed"
kubectl rollout restart -n pms deployment || warn "restart of pms deployments failed"
kubectl rollout restart -n resident deployment || warn "restart of resident deployments failed"
kubectl rollout restart -n print deployment || warn "restart of print deployments failed"
kubectl rollout restart -n digitalcard deployment || warn "restart of digitalcard deployments failed"
kubectl rollout restart -n regproc deployment regproc-notifier || warn "restart of regproc-notifier failed"
kubectl rollout restart -n regproc deployment regproc-workflow || warn "restart of regproc-workflow failed"
kubectl rollout restart -n regproc deployment regproc-reprocess || warn "restart of regproc-reprocess failed"

log "All restarts triggered. Now waiting for every new pod to come up..."

# Wait for all deployments in the namespace-wide restarts
for ns in idrepo pms resident print digitalcard; do
  for name in $(kubectl get deployment -n "${ns}" -o jsonpath='{.items[*].metadata.name}' 2>/dev/null); do
    wait_rollout "${ns}" deployment "${name}"
  done
done
# Wait for the individually named services
wait_rollout regproc deployment regproc-notifier
wait_rollout regproc deployment regproc-workflow
wait_rollout regproc deployment regproc-reprocess

##############################################################################
# Summary
##############################################################################
if [ ${#WARNINGS[@]} -eq 0 ]; then
  log "✅ ALL NEW PODS ARE UP — every service restarted and became ready within ${TIMEOUT}."
else
  log "⚠️  Restart cycle finished, but ${#WARNINGS[@]} warning(s) occurred:"
  for w in "${WARNINGS[@]}"; do
    echo "   - ${w}"
  done
  echo "   (These services may still be starting — check with: kubectl get pods -A)"
fi
exit 0
