#!/bin/bash

set -e
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail

# Configuration
DB_USER="${DB_USER}"
DB_HOST="${DB_HOST}"
DB_PORT="${DB_PORT}"
DB_PASSWORD="${DB_PASSWORD}"
S3_BUCKET="${S3_BUCKET}"
S3_FOLDER="${S3_FOLDER}"
EXPECTED_SIZE="${EXPECTED_SIZE}" # Expected size in bytes
NUM_BACKUPS_TO_KEEP="${NUM_BACKUPS_TO_KEEP}"  # Number of latest backups to retain
DATE=$(date -u +"%Y-%m-%d-%H-%M-%S-UTC")
BACKUP_FILE="$S3_FOLDER-$DATE.dump"
AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID}"
AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY}"
AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION}"

# Set AWS CLI configuration for large file handling
#aws configure set default.s3.max_concurrent_requests 100  # Adjust this as needed
#aws configure set default.s3.multipart_threshold 500MB   # Adjust this as needed

# Function to log messages to terminal
log_message() {
    local MESSAGE=$1
    local LOG_LEVEL=$2
    echo "$(date -u +"%Y-%m-%d %H:%M:%S UTC") [$LOG_LEVEL] $MESSAGE"
}

echo "DB_USER=${DB_USER}"
echo "DB_HOST=${DB_HOST}"
echo "DB_PORT=${DB_PORT}"
echo "S3_BUCKET=${S3_BUCKET}"
echo "S3_FOLDER=${S3_FOLDER}"

# Notify that the backup process is starting
log_message "Backup started..." "INFO"


# Dump PostgreSQL database and stream it to S3
PGPASSWORD=$DB_PASSWORD pg_dumpall -c --if-exists -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" | aws s3 cp - "s3://$S3_BUCKET/$S3_FOLDER/$BACKUP_FILE" --expected-size=""$EXPECTED_SIZE"


if [ $? -eq 0 ]; then
    log_message "Backup successfully uploaded to S3: s3://$S3_BUCKET/$S3_FOLDER/$BACKUP_FILE" "INFO"
else
    log_message "Backup failed!" "ERROR"
    exit 1
fi

# Keep only the latest NUM_BACKUPS_TO_KEEP backups
log_message "Cleaning up backups to retain only the latest $NUM_BACKUPS_TO_KEEP files..." "INFO"

# List files in S3 bucket, sort by date, and process them
BACKUP_COUNT=0
aws s3 ls s3://$S3_BUCKET/$S3_FOLDER/ | sort -r | awk '{print $4}' | while read -r FILE_NAME; do

    # Increment backup count
    BACKUP_COUNT=$((BACKUP_COUNT + 1))

    # Delete backups beyond the latest NUM_BACKUPS_TO_KEEP
    if [ $BACKUP_COUNT -gt $NUM_BACKUPS_TO_KEEP ]; then
        log_message "Deleting old backup: $FILE_NAME" "INFO"
        aws s3 rm s3://$S3_BUCKET/$S3_FOLDER/$FILE_NAME
    fi
done

log_message "Cleanup process completed." "INFO"