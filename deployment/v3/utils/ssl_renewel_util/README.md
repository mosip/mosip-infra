# SSL Certificate Renewal Script for Aws
Note: If you are not using Aws as your Dns provider then this script won't work. You'll have to manually renewel the certificates, In case if you are using any other Dns provider then check if certbot supports any dns plugin for your Dns provider and then just update the certbot command then the script should work fine.

This script is used for the renewal of SSL certificates using Let's Encrypt's `certbot`. It moves old certificates to a backup directory with an expiry date and renew the ssl certificates and Update cert location.

## Prerequisites

- **Certbot**: Ensure `certbot` is installed and configured on your system.
- **AWS Route 53**: The script uses Route 53 for DNS challenges.
- **Sudo Privileges**: Required to move directories and restart services.
- **Nginx**: Ensure Nginx is installed and configured to use Let's Encrypt certificates.

## Installation

1. **Install Certbot**: Follow the instructions [here](https://certbot.eff.org/instructions) to install `certbot` for your web server and operating system.
2. **Configure AWS Route 53**: Ensure your domain's DNS is managed by AWS Route 53 and that you have the necessary permissions to perform DNS validation.
3. **Script Permissions**: Make sure the script has execute permissions:
    ```sh
    chmod +x renew_ssl_certs.sh
    ```

## Usage

Run the script with the necessary permissions:

```sh
sudo ./renew_ssl_certs.sh
```

In Order to Automate the renewal of SSL certificates we have created another script which exicutes the `renew_ssl_certs` script on the date of expiry using a cron.

# Schedule Certs Renew Cron Script

This script schedules a cron job to run a specified script (`renew_ssl_certs.sh`) at 6am on a user-defined expiry date.

## Prerequisites

- `cron` installed and running
- Permissions to edit cron jobs for the current user

## Script Overview

The script performs the following steps:

1. Prompts the user to enter an expiry date in `YYYY-MM-DD` format.
2. Converts the provided expiry date to the appropriate format for scheduling a cron job.
3. Schedules a cron job to run `renew_ssl_certs.sh` at 6am on the specified expiry date.
4. Displays a confirmation message once the job is scheduled.

## Usage

1. **Make the Script Executable**

   Before running the script, ensure it has executable permissions:

   ```bash
   chmod +x certs_renew_cron.sh

2. **Run the script**
   
   Run the script with the necessary permissions:

   ```sh
   sudo ./certs_renew_cron.sh
   ```
   
3. **Verify the Scheduled Cron Job**

   Run the below command to verify the scheduled cronjob with specific date and time.
   
   ```sh
   crontab -l
   ```

## Troubleshooting

* No Crontab for User: If you see no crontab for <user>, it means there are no existing cron jobs for the user. The script will still create the new cron job.
* Invalid Date Format: Ensure you enter the date in YYYY-MM-DD format.
* Permission Issues: Ensure you have the necessary permissions to edit cron jobs for the current user.
