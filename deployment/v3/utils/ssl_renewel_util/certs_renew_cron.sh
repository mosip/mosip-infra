#!/bin/bash
# script is the schedule cron to run the certs renewal script on the expiry date.

# Prompt the user for the expiry date
read -p "Enter the expiry date (YYYY-MM-DD): " expiry_date

# Convert the expiry date to a cron format (minute hour day month)
cron_time="0 6 $(date -d "$expiry_date" +'%d') $(date -d "$expiry_date" +'%m') *"

# Define the command you want to run on the expiry date
command_to_run="renew_certificates.sh"

# Create a cron job
(crontab -l; echo "$cron_time $command_to_run") | crontab -

echo "Scheduled job for $expiry_date to run at 6am."