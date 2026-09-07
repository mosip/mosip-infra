# Kafka restart utility

Shell script to restart Kafka and every MOSIP module that depends on it, in the
correct order, on Kubernetes.

Restarting Kafka on its own is not enough — Zookeeper, `kafka-ui` and all the
downstream consumers have to be cycled with it, and `websub` must be scaled to
zero first so its PVC is not held open while the brokers bounce.

## Restart sequence

1. Record the current replica count of every `websub` deployment, then scale
   them all to 0 and wait for the pods to terminate. If the replica counts
   cannot be read, the script aborts here without touching anything (see
   [Behaviour on failure](#behaviour-on-failure)).
2. Restart the `kafka` statefulsets (kafka + zookeeper) and the `kafka-ui`
   deployment together, then wait for all of them to become ready.
3. Scale `websub-consolidator` back up, then `websub`, then any other
   deployment recorded in step 1 — each restored to the exact replica count it
   had, not blindly to 1. A deployment that was already at 0 replicas is left
   down rather than being brought up.
4. Restart `kernel/syncdata`, then `kernel/masterdata`.
5. Restart every deployment in the `ida` namespace and wait for all of them.
6. Trigger `idrepo`, `pms`, `resident`, `print`, `digitalcard` and the
   `regproc-notifier` / `regproc-workflow` / `regproc-reprocess` deployments
   simultaneously, then wait for every rollout.

## Usage

```sh
./kafka-restart.sh                 # 300s wait per rollout (default)
TIMEOUT=600s ./kafka-restart.sh    # custom wait per rollout
```

The script acts on the **current `kubectl` context**. Confirm it before running:

```sh
kubectl config current-context
```

### If the file is not executable

The script is committed with mode `755`, so a `git clone` or an extracted
ZIP/tarball of the repository already gives you an executable file. A file
fetched over plain HTTP — `curl`/`wget` against `raw.githubusercontent.com`,
or copy-pasted into an editor — cannot carry a permission bit, and will need:

```sh
chmod +x kafka-restart.sh
```

## Behaviour on failure

Once the restart is under way the script deliberately does **not** use
`set -e`. A rollout that times out or a step that fails logs a warning and the
run continues to the next module, so a single slow service cannot leave the
cluster half-restarted. Every warning is collected and reprinted as a summary
at the end, and the script exits 0.

If the summary is non-empty, the named services may simply still be starting:

```sh
kubectl get pods -A
```

### The one case that aborts

Reading the `websub` replica counts in step 1 is a hard pre-condition. If that
`kubectl get` fails, or returns no deployments at all, the script prints a
`FATAL` line and **exits 1 without modifying anything**.

This is deliberate. Scaling `websub` to zero without a record of what to
restore would strand deployments at zero replicas with nothing to recover them
from, so the safe response is to stop before the first destructive step rather
than proceed on a guess. Nothing has been scaled or restarted at that point,
so the script is safe to simply re-run once the cause is fixed — usually a
wrong `kubectl` context, a missing `websub` namespace, or RBAC.

Exit codes:

| Code | Meaning |
|------|---------|
| `0`  | Run completed. Check the summary for warnings. |
| `1`  | Pre-flight failure reading websub replica counts. Nothing was modified. |

## Requirements

* `kubectl`, configured and pointing at the target cluster
* Permission to `scale`, `rollout restart` and `rollout status` in the
  `websub`, `kafka`, `kernel`, `ida`, `idrepo`, `pms`, `resident`, `print`,
  `digitalcard` and `regproc` namespaces
* **bash 4.4 or newer.** The script uses an associative array (`declare -A`)
  to record replica counts, and relies on `${#array[@]}` being safe on an empty
  array under `set -u` — both need 4.4+. Ubuntu 20.04 and later ship 5.x;
  older jump hosts and stock macOS bash 3.2 will not work.
