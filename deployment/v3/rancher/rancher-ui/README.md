## Rancher

Install rancher using Helm, update ```hostname``` in ```rancher-values.yaml``` and run the following command to install.

    ```
    helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
    helm repo update
    helm install rancher rancher-latest/rancher \
      --namespace cattle-system \
      --create-namespace \
      -f rancher-values.yaml
    ```

## Login
* Open Rancher page `https://rancher.mosip.net`.
* Get Bootstrap password using
    ```
    kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{ .data.bootstrapPassword|base64decode}}{{ "\n" }}'
    ```
* Assign a password.  IMPORTANT: makes sure this password is securely saved and retrievable by Admin.