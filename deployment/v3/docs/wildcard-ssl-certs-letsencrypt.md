# Generating SSL Certificates with Letsencrypt

* Make sure python3 is installed.
* Install letsencrypt and certbot packages.
```
sudo apt install letsencrypt
sudo apt install certbot python3-certbot-nginx
```
* Generate Certificates.
```
sudo certbot certonly --agree-tos --manual --preferred-challenges=dns -d mosip.xyz.net -d *.mosip.xyz.net
```
  * This default challenge is http challenge, but we have changed it to dns challenge, because we want wildcard certificates.
  * What this means is that, this will ask to create a dns record, type TXT, with host _acme-challenge.mosip.xyz.net, with a specific text string.
  * Create that particular dns entry, and wait for a few minutes till it comes up. Use the following command to validate if the dns entry is up.
    ```
    host -t TXT _acme-challenge.mosip.xyz.net
    ```
  * Press enter in the `certbot` prompt to proceed.
  * It uses the above dns and matches the text string to validate the domains, and generate the certificates.
* Use the certificates generated in /etc/letsencrypt in your webserver.
