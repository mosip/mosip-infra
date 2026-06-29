# Kubernetes Cluster Health Check

A GitHub Actions workflow that automatically checks the health of all MOSIP Kubernetes environments every 6 hours and sends Slack alerts when issues are detected.

---

## Table of Contents

- [Overview](#overview)
- [How It Works](#how-it-works)
- [Checks Performed](#checks-performed)
- [Environments](#environments)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
    - [GitHub Secrets](#github-secrets)
    - [WireGuard Server Configuration](#wireguard-server-configuration)
    - [Adding a New Environment](#adding-a-new-environment)
- [Triggering the Workflow](#triggering-the-workflow)
- [Understanding the Output](#understanding-the-output)
- [Troubleshooting](#troubleshooting)

---

## Overview

```
Cron (every 6h) or Manual trigger
           │
           ▼
   Build Environment Matrix
   (resolves which envs to check)
           │
           ▼
   Health Check per Environment   ← sequential, one at a time
   ├── C1: Failing Services
   ├── C2: Pod Restarts
   ├── C3: Disk Space (NFS / ActiveMQ / Postgres)
   └── C4: Cluster Health (Nodes, PVCs, Helm, Observability)
           │
           ▼
   Slack Notification per env
           │
           ▼
   Consolidated Summary (all envs)
```

---

## How It Works

The workflow runs in **three jobs**:

### Job 1 — Build Environment Matrix
Reads the list of all environments defined in the workflow and decides which ones to check. On a cron trigger it checks all environments. On a manual trigger it checks only the environments you specify.

### Job 2 — Health Check (per environment, sequential)
Runs once per environment in sequence (`max-parallel: 1`). Each run:
1. Connects to the cluster via WireGuard VPN
2. Writes the kubeconfig for that environment
3. Runs 4 health checks (C1–C4)
4. Sends a Slack notification for that environment

### Job 3 — Consolidated Summary
Waits for all environments to finish then sends a single summary Slack message showing whether all environments passed or any had issues.

---

## Checks Performed

### C1 — Failing Services
Detects pods that are not in `Running`, `Completed`, or `Succeeded` state. Also catches:
- `CrashLoopBackOff` pods (reported as a GitHub Actions error annotation)
- Deployments with 0 available replicas (service is completely down)
- Services with no endpoints (traffic goes nowhere)

### C2 — Pod Restarts
Detects pods that have restarted within a time window. The window is adaptive:

| Day | Window |
|---|---|
| Monday | Last 72 hours (catches weekend incidents) |
| Tuesday – Sunday | Last 24 hours |

Uses pod start time as a proxy for restart time since Kubernetes does not expose restart timestamps directly.

### C3 — Disk Space
Checks disk usage on external VMs via SSH and in-cluster Postgres via `kubectl exec`. Only alerts when usage is **≥ 90%**. Shows a warning in the summary at 80%.

| Mount | How checked | Skipped if |
|---|---|---|
| `/srv/nfs` | SSH → `df -h` | Not mounted on VM |
| `/srv/activemq` | SSH → `df -h` | Not mounted on VM |
| `/srv/postgres` | SSH → `df -h` (if `postgres_mode: vm`) | Not mounted on VM |
| `/bitnami/postgresql` | `kubectl exec` (if `postgres_mode: incluster`) | Pod not found |

Each mount is checked with `mountpoint -q` first — if the path is not mounted it is **skipped instantly** rather than hanging.

### C4 — Cluster Health
- **Node status** — counts how many nodes are Ready
- **PVC status** — lists any PVCs not in `Bound` state
- **Helm releases** — lists any releases in `failed` or `pending` state
- **Observability stack** — checks pods in `cattle-monitoring-system` and `loki-monitoring` namespaces
- **Warning events** — lists Kubernetes warning events from the last 30 minutes

---

## Environments

Environments are defined in the `build-matrix` job inside the workflow file:

```json
{"env":"qajava21",     "channel":"#cluster_health", "vm_host":"postgres.qajava21.mosip.net",     "postgres_mode":"vm"},
{"env":"esperf",       "channel":"#cluster_health", "vm_host":"postgres.esperf.mosip.net",       "postgres_mode":"incluster"},
{"env":"dev-int-inji", "channel":"#cluster_health", "vm_host":"postgres.dev-int-inji.mosip.net", "postgres_mode":"incluster"},
{"env":"dev",          "channel":"#cluster_health", "vm_host":"postgres.dev.mosip.net",          "postgres_mode":"vm"},
{"env":"dev11",        "channel":"#cluster_health", "vm_host":"postgres.dev11.mosip.net",        "postgres_mode":"vm"},
{"env":"dev2",         "channel":"#cluster_health", "vm_host":"postgres.dev2.mosip.net",         "postgres_mode":"vm"},
{"env":"esdev",        "channel":"#cluster_health", "vm_host":"postgres.esdev.mosip.net",        "postgres_mode":"incluster"},
{"env":"esqa2",        "channel":"#cluster_health", "vm_host":"postgres.esqa2.mosip.net",        "postgres_mode":"incluster"},
{"env":"qa11new",      "channel":"#cluster_health", "vm_host":"postgres.qa11new.mosip.net",      "postgres_mode":"vm"},
{"env":"qainji",       "channel":"#cluster_health", "vm_host":"postgres.qainji.mosip.net",       "postgres_mode":"incluster"}
```

| Field | Description |
|---|---|
| `env` | Environment name — used in secret lookup, Slack messages, step headers |
| `channel` | Slack channel for that environment's alert |
| `vm_host` | External VM to SSH into for NFS / ActiveMQ / Postgres disk checks |
| `postgres_mode` | `vm` = Postgres is on the external VM · `incluster` = Postgres runs inside Kubernetes |

---

## Prerequisites

- GitHub Actions enabled on the repository
- WireGuard server running and reachable at `3.7.248.153:51820`
- The WireGuard server must be inside the same AWS VPC as the Rancher/RKE2 clusters
- SSH access to each environment's external VM for disk checks
- A Slack app with an Incoming Webhook configured

---

## Setup

### GitHub Secrets

Create all of the following secrets under **Settings → Secrets and variables → Actions**.

#### Kubeconfig secrets (one per environment)

Secret name format: `KUBECONFIG_<ENV_UPPERCASE_UNDERSCORES>`

| Environment | Secret name |
|---|---|
| `qajava21` | `KUBECONFIG_QAJAVA21` |
| `esperf` | `KUBECONFIG_ESPERF` |
| `dev-int-inji` | `KUBECONFIG_DEV_INT_INJI` |
| `dev` | `KUBECONFIG_DEV` |
| `dev11` | `KUBECONFIG_DEV11` |
| `dev2` | `KUBECONFIG_DEV2` |
| `esdev` | `KUBECONFIG_ESDEV` |
| `esqa2` | `KUBECONFIG_ESQA2` |
| `qa11new` | `KUBECONFIG_QA11NEW` |
| `qainji` | `KUBECONFIG_QAINJI` |

Generate the secret value for each environment:
```bash
# On the machine that has access to the cluster
base64 -w0 ~/.kube/config-qajava21
# Paste the output as the secret value
```

> **Important:** Hyphens are not allowed in GitHub secret names. Always replace `-` with `_` and use uppercase. `dev-int-inji` → `KUBECONFIG_DEV_INT_INJI`.

#### WireGuard secret

| Secret name | Value |
|---|---|
| `CLUSTER_WIREGUARD_WG0` | Full contents of the `wg0.conf` WireGuard config file |

#### SSH key for disk checks

| Secret name | Value |
|---|---|
| `DISK_CHECK_SSH_KEY` | Private key (`.pem` or `id_ed25519`) used to SSH into the external VMs |

The corresponding public key must be in `~/.ssh/authorized_keys` on each external VM for the `ubuntu` user.

Verify it works before setting the secret:
```bash
ssh -i ~/.ssh/your-key.pem ubuntu@postgres.qajava21.mosip.net "df -h /srv/nfs"
```

#### Slack webhook

| Secret name | Value |
|---|---|
| `SLACK_WEBHOOK_URL` | `https://hooks.slack.com/services/T.../B.../...` |

Get this from your Slack app under **Incoming Webhooks**.

---

### WireGuard Server Configuration

The WireGuard server at `3.7.248.153` must have a peer entry for the GitHub Actions runner. Since `max-parallel: 1` ensures only one runner connects at a time, a single peer is sufficient.

On the WireGuard server (`/etc/wireguard/wg0.conf`):
```ini
[Interface]
PrivateKey = <server-private-key>
Address = 10.13.13.1/24
ListenPort = 51820

[Peer]
# GitHub Actions runner
PublicKey = <runner-public-key>
AllowedIPs = 10.13.13.2/32
PersistentKeepalive = 25
```

The runner's `wg0.conf` (stored in `CLUSTER_WIREGUARD_WG0` secret):
```ini
[Interface]
PrivateKey = <runner-private-key>
Address = 10.13.13.2/32

[Peer]
PublicKey = <server-public-key>
Endpoint = 3.7.248.153:51820
AllowedIPs = 172.31.0.0/16
PersistentKeepalive = 25
```

Make sure UDP port 51820 is open inbound on the WireGuard server's AWS security group.

---

### Adding a New Environment

**Step 1** — Add an entry to `ALL_ENVS` in the workflow file:
```json
{"env":"newenv", "channel":"#cluster_health", "vm_host":"postgres.newenv.mosip.net", "postgres_mode":"vm"}
```

**Step 2** — Create the kubeconfig secret:
```bash
gh secret set KUBECONFIG_NEWENV --body "$(base64 -w0 ~/.kube/config-newenv)"
```

**Step 3** — Add the secret to the `env:` block in the `Write kubeconfig` step:
```yaml
KUBECONFIG_NEWENV: ${{ secrets.KUBECONFIG_NEWENV }}
```

**Step 4** — Add the runner's SSH public key to the new VM:
```bash
ssh-copy-id -i ~/.ssh/disk_check_key.pub ubuntu@postgres.newenv.mosip.net
```

---

## Triggering the Workflow

### Automatic (cron)
Runs automatically every 6 hours at minute 0:
```
0 */6 * * *   →   00:00, 06:00, 12:00, 18:00 UTC
```
All environments are checked on every cron run.

### Manual trigger

1. Go to **Actions** tab in the repository
2. Click **Kubernetes Cluster Health Check** in the left sidebar
3. Click **Run workflow**
4. Fill in the inputs:

| Input | Description |
|---|---|
| `environments` | Comma-separated list of env names, or leave blank for all. e.g. `qajava21,dev` |
| `notify_slack` | Whether to send Slack notifications (default: `true`) |

5. Click **Run workflow**

Valid environment name examples:

| What you want | What to type |
|---|---|
| All environments | *(leave blank)* |
| Just QA | `qajava21` |
| Multiple specific | `qajava21,dev,esperf` |
| All ES environments | `esdev,esqa2,esperf` |

> Spaces after commas are stripped automatically — `qajava21, dev` and `qajava21,dev` both work.

---

## Understanding the Output

### GitHub Actions Step Summary
Each environment's health check produces a detailed summary visible under the **Summary** tab of the Actions run. It includes tables for failing pods, disk usage, node status, and warning events.

### Slack Notifications

**Per-environment alert** (sent to the environment's channel after each env completes):

```
✅ [qajava21] All Services Healthy
All checks passed. Nodes: 3/3 Ready

— or —

🚨 [dev] Health Issues Detected
• Failing Services: 2 unhealthy pod(s)
• Disk Alerts (>90%): NFS Storage (/srv/nfs) on postgres.dev.mosip.net: 93% used
```

**Consolidated summary** (sent once after all environments finish):
```
✅ All Environments Healthy — 2026-06-29 06:00 UTC

— or —

🚨 One or More Environments Have Issues — 2026-06-29 06:00 UTC
Review individual environment notifications and the Actions run for details.
```

### Health Gate Logic

The overall health status per environment is determined by:

| Check | Fails the gate? |
|---|---|
| C1 — Any pod not Running/Completed | ✅ Yes |
| C1 — Any deployment with 0 replicas | ✅ Yes |
| C2 — Pods restarted in window | ✅ Yes |
| C3 — Any disk ≥ 90% | ✅ Yes |
| C4 — Any node NOT Ready | ✅ Yes |
| C1 — Services with no endpoints | ⚠️ Reported only |
| C3 — Disk 80–89% | ⚠️ Warning in summary only |

---

## Troubleshooting

### `matrix must define at least one vector`
The environment matrix is empty. Causes:
- JSON syntax error in `ALL_ENVS` (missing comma between entries)
- Manual trigger with an env name that doesn't match any entry in `ALL_ENVS`

Check the `Build Environment Matrix` job logs for a `jq: parse error` message.

### `dial tcp 172.31.15.240:443: i/o timeout`
The WireGuard tunnel is not routing traffic to the private IP. Check:
- UDP 51820 is open inbound on the WireGuard server's security group
- `sudo wg show` on the server shows a recent handshake for the runner's peer
- `PersistentKeepalive = 25` is in the `[Peer]` block of `wg0.conf`

### `Permission denied (publickey)` on SSH disk checks
The public key corresponding to `DISK_CHECK_SSH_KEY` is not in `authorized_keys` on the target VM. Run:
```bash
ssh-copy-id -i ~/.ssh/disk_check_key.pub ubuntu@<vm_host>
```

### `Secret KUBECONFIG_XYZ is empty or not set`
The kubeconfig secret for that environment is missing or named incorrectly. Secret names must be uppercase with hyphens replaced by underscores:
```bash
# For env "dev-int-inji"
gh secret set KUBECONFIG_DEV_INT_INJI --body "$(base64 -w0 ~/.kube/config-dev-int-inji)"
```

### C3 disk check times out
A mount on the external VM is hanging (common with stale NFS mounts). The workflow skips mounts that are not present using `mountpoint -q`. If a mount exists but hangs, the step will time out after 5 minutes and continue. Investigate the VM directly:
```bash
ssh ubuntu@<vm_host> "df -h"
```

### `TLS handshake timeout` mid-job
The WireGuard tunnel dropped between steps. Ensure `PersistentKeepalive = 25` is set in the peer config. If running parallel environments, switch to `max-parallel: 1` to avoid multiple runners competing for the same WireGuard peer.