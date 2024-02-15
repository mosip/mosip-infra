# Change domain name in a running env ( v2 )

Follow the below steps to rename domain name in a running v2 env:
1. Update the domain name in groups/all.yml
2. Ran playbooks/nginx.yml
3. Redeploy config-server, keycloak
4. Update  the domain name in the  valid redirect URL & web origins of mosip keycloak-clients 
5. Updated domain name admin-ui, prereg-ui configmaps. 
6. Restart mosip modules.

# Change domain name in a running env ( v3 )

Follow the below steps to rename domain name in a running v3 env:
1. Update DNS records from the old DNS name to the new DNS name i.e., (from `*.country-data.mosip.net` to `*.data.mosip.net` ).
2. Generate SSL certs for the new domain.
   * Backup the old SSL certs via the below command:
     ```
     sudo mv /etc/letsencrypt/live /etc/letsencrypt/live-{date}
     ```
   * Generate SSL certs for new domain via the below command:
     ```
     sudo certbot certonly --agree-tos --manual --preferred-challenges=dns -d *.<new-dns-name> -d <new-dns-name>
     ```
     Example:
     ```
     sudo certbot certonly --agree-tos --manual --preferred-challenges=dns -d *.data.mosip.net -d data.mosip.net
     ```
3. Update ssl certs location and domain names in nginx config file `/etc/nginx/nginx.conf` and restart nginx service.
   ```
   ssl_certificate /etc/letsencrypt/live/data.mosip.net/fullchain.pem;   
   ssl_certificate_key /etc/letsencrypt/live/data.mosip.net/privkey.pem;
   ```
   ```
   ## public IP server section
   server{
     listen 216.48.176.35:443 ssl;
     server_name  api.data.mosip.net prereg.data.mosip.net resident.data.mosip.net esignet.data.mosip.net;
     location / {
        proxy_pass                      <http://myPublicIngressUpstream;>
        proxy_http_version              1.1;
        ....
        ....
       }
   }
   ```
   ```
   sudo systemctl restart nginx
   ```
4. Update the domain in `global` configmaps on the `default` namespace.
5. Update the iam domain in `keycloak-host` configmaps on `keycloak` namespace.
6. Copy the `global` configmaps on all the required namespaces.
   ```
   namespaces=$(kubectl get cm -A  | grep  'global' | awk '{print $1}' | grep -v 'default' )
   for ns in $namespaces; do
   echo "NS $ns"
   ./copy_cm_func.sh configmap global default $ns
   done
   ```
7. Copy the `keycloak-host` configmaps on all the required namespaces.
   ```
   namespaces=$(kubectl get cm -A  | grep  'keycloak-host' | awk '{print $1}' | grep -v 'keycloak' )
   for ns in $namespaces; do
      ./copy_cm_func.sh configmap keycloak-host keycloak $ns
   done
   ```
8. Update the domains in gateways  & virtual service via the below commands:
   ```
   kubectl get gateways -A -o yaml > istio-gateways.yaml
   sed -i 's/country-data/data/g' istio-gateways.yaml
   kubectl apply -f istio-gateways.yaml
   ```
   ```
   kubectl get vs -A  -o yaml > istio-virtualservice.yaml
   sed -i 's/country-data/data/g' istio-virtualservice.yaml
   kubectl apply -f istio-virtualservice.yaml
   ```
9. Update the domain names in `landing-page-index` configmaps in the `landing-page` namespace and restart the landing-page service. 
10. Update the domain name in all ui configmaps (i.e., admin-ui, prereg-ui, pmp ui, resident ui, esignet ui, compliance ui, healthservices UI, etc...). 
11. Update the iam domain url for the `Frontend URL` for the `mosip` realm. 
12. Update the domain in `regclient-index` configmaps & env variables in regclient deployment  for `regclient`.
    ```
      containers:
      - env:
        - name: client_version_env
          value: 1.2.0.1-B1
        - name: client_upgrade_server_env
          value: https://regclient.data.mosip.net
        - name: healthcheck_url_env
          value: https://api-internal.data.mosip.net/v1/syncdata/actuator/health
        - name: host_name_env
          value: api-internal.data.mosip.net
    ```
13. Restart config-server and all other mosip services. 
14. Update the domains in apitestrig, dslrig, uitestrig configmaps before running.

 