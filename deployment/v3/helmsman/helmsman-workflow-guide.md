# Deploy External Services of MOSIP using Helmsman

This repository contains a GitHub Actions workflow to deploy external services of MOSIP using Helmsman. The workflow supports multiple modes (`dry-run` and `apply`) and handles essential setup tasks like configuring WireGuard, installing Helm and Helmsman, and applying configurations of DSF files.

---

## Workflow Overview

The workflow is triggered by:
- **Manual Dispatch**: Allowing users to select the mode (`dry-run` or `apply`).
- **Push Events**: Monitoring changes in the `deployment/v3/helmsman/dsf/` directory.

The deployment is done in a matrix strategy to handle multiple configuration files for WireGuard and DSF (Deployment Specification Files).

### Inputs to be provided to run workflow.

### `mode`
- **Description**: Choose the mode in which Helmsman runs.
- **Required**: Yes
- **Default**: `dry-run`
- **Options**:
    - `dry-run`: Simulates the deployment without making changes.
    - `apply`: Applies the deployment changes.

### Secrets

The following secrets are required to run this workflow:
- `CLUSTER_WIREGUARD_WG0`: WireGuard configuration for `wg0`.
- `CLUSTER_WIREGUARD_WG1`: WireGuard configuration for `wg1`.
- `KUBECONFIG`: The Kubernetes configuration file for cluster access.

### Steps Performed:

1. **Repository Checkout**
- Fetches the repository to work with the required configuration files.

2. **Set Default Mode**
- Sets the deployment mode based on the user input or defaults to `apply`.

3. **Setup UFW Firewall**
- Enables the firewall.
- Allows SSH and WireGuard (UDP port 51820).

4. **Install WireGuard**
- Installs WireGuard to enable secure communication with clusters.

5. **Configure WireGuard**
- Configures WireGuard using the provided secret configuration files.

6. **Start WireGuard**
- Starts the WireGuard service for secure network communication.

7. **Setup Helm**
- Installs Helm, a Kubernetes package manager.

8. **Install Helmsman**
- Installs Helmsman, a tool for managing Helm charts.

9. **Apply Helmsman Configurations**
- Prepares the Kubernetes environment (kubectl, Istio CLI).
- Uses Helmsman to deploy DSF configurations in the specified mode.

### Triggering the Workflow Manually
1. Navigate to the "Actions" tab in your repository.
2. Select the `Deploy External Services` workflow.
3. Click on "Run workflow."
4. Choose the mode (`dry-run` or `apply`) and start the workflow.

### Triggering on Push
- Commit and push changes to `deployment/v3/helmsman/dsf/` to automatically trigger the workflow.

## Prerequisites

- Ensure the necessary secrets (`CLUSTER_WIREGUARD_WG0`, `CLUSTER_WIREGUARD_WG1`, `KUBECONFIG`) are configured in the repository settings.
- The target Kubernetes cluster should be accessible via the provided `KUBECONFIG`.

---

## Debugging and Logs

- The workflow runs with `--debug` mode enabled for Helmsman to provide detailed logs.
- Logs can be viewed in the "Actions" tab of the repository under the respective workflow run.

---

> **Note:**
> - This directory is a **work-in-progress** and currently **experimental**.
> - It is subject to changes as we continue to refine the deployment process.
> - Contributions and feedback are welcome as part of ongoing development!