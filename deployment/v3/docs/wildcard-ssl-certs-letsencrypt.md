# SSL Certificates with Letsencrypt

* Install `python3`.
* Install letsencrypt and certbot packages.
```
sudo apt install letsencrypt
sudo apt install certbot python3-certbot-nginx
```
* Generate certificates for your domain name.
```
sudo certbot certonly --agree-tos --manual --preferred-challenges=dns -d *.mosip.xyz.net
```
   * The default challenge HTTP is changed to DNS challenge, as we require wildcard certificates.
   * Create a DNS record in your DNS service of type TXT with host `_acme-challenge.mosip.xyz.net`, with the string prompted by the script.
  * Wait for a few minutes for the above entry to get into effect. Verify: 
    ```
    host -t TXT _acme-challenge.mosip.xyz.net
    ```
  * Press enter in the `certbot` prompt to proceed.
* Certificates are created in `/etc/letsencrypt` on your machine.
