# Identity Cache Cleanup Automation

## Context
* This utility automates the periodic clearing of the identity_cache table from the mosip_ida PostgreSQL database.
* The cleanup is scheduled via a Kubernetes CronJob and implemented using a Bash script.
* Helps maintain database performance by removing stale cached identity data.

## Prerequisites
* PostgreSQL database accessible from the Kubernetes cluster.
* DB credentials with privileges to TRUNCATE the identity_cache table.

## Install
```./install.sh```

## During execution, the script will prompt for database connection details. Example session:

* Enter DB Host: your-db-host
* Enter DB Port [default 5432]: your-db-port
* Using DB Username: postgres
* Enter DB Password for user postgres: your-postgres-password

# NOTE
* This CronJob is configured to execute on the first day of each month. You may modify the schedule or suspend the job according to operational requirements.