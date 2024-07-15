#!/bin/bash
# Script to renew ssl certificates..

# Prompt the user for the expiry date
read -p "Enter the expiry date of existing ssl certs (e.g., 2024-12-31): " expiry_date

# Define the source and destination directories
src_dir="/etc/letsencrypt/live"
dest_dir="/etc/letsencrypt/live-${expiry_date}"

# Check if the source directory exists
if [ -d "$src_dir" ]; then
    # Move the directory
    sudo mv "$src_dir" "$dest_dir"
    echo "Directory moved to $dest_dir"
else
    echo "Source directory $src_dir does not exist."
fi

# Regenerate the ssl certificates
# Prompt the user for the domain name
read -p "Enter the domain name (e.g., sandbox.xyz.net): " domain

# Check if the domain is not empty
if [ -z "$domain" ]; then
    echo "Domain name cannot be empty"
    exit 1
fi

# Run certbot with the user-provided domain name
sudo certbot certonly \
  --dns-route53 \
  -d "$domain" \
  -d "*.$domain"

# Rename the new certificates
sudo mv /etc/letsencrypt/live/$domain-* /etc/letsencrypt/live/$domain

# Restart the Nginx service
sudo systemctl restart nginx