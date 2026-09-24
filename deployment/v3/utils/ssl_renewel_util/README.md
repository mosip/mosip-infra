# SSL Renewal Utility

This utility installs a daily cron job to renew Let's Encrypt certificates and reload nginx automatically.

## Files

- `certs_renew_cron.sh`: installs or updates the daily cronjob.
- `renew_ssl_certs.sh`: runs `certbot renew` and reloads nginx when renewal succeeds.

## Usage

1. Copy both scripts to the nginx VM under `/opt/ssl_renewal` or another stable location.
2. Make both scripts executable:

```bash
sudo chmod +x certs_renew_cron.sh renew_ssl_certs.sh
```

3. Install the cron job:

```bash
sudo ./certs_renew_cron.sh
```

4. Verify the cron entry:

```bash
sudo crontab -l | grep renew_ssl_certs.sh
```

## Requirements

- `certbot` installed on the nginx VM
- `nginx` service present on the VM
- SSL certificates managed under `/etc/letsencrypt`

## Notes

- The cron job runs daily at midnight.
- Renewal output is logged to `/var/log/ssl_renewal.log`.
- Cron installer logs to `/var/log/ssl_renewal.cron.log`.
