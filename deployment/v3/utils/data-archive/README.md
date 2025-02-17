# Database Archiving Configuration

This configuration file is used for setting up database connections and defining archiving parameters. Please follow the guidelines below to fill in the required information.

## Database Connections

### Archive Database Connection (archive_db)

- `db_name`: Name of the archive database.
- `host`: Destination host for the archive database.
- `port`: Port number for the archive database connection.
- `su_user`: Superuser for the archive database.
- `su_user_pwd`: Password for the superuser.
- `db_pwd`: Password for the archive database.
- `archivehost`: Destination host for the archive database.
- `archiveport`: Port number for the archive database connection.
- `archiveuname`: Archive database username.
- `archive_dbname`: Archive database name.
- `archive_schemaname`: Archive schema name.
- `archive_db_password`: Password for the archive database.
- `batch_size`: Number of records processed in each batch.



### Database Names

A list of databases to be archived:

```yaml
  db_names:
    - name: audit
      enabled: true
      container_volume_path: /audit-table-info  ## volume mount path for table info inside cronjob container
    - name: ida
      enabled: true
      container_volume_path: /ida-table-info  ## volume mount path for table info inside cronjob container
    - name: credential
      enabled: true
      container_volume_path: /credential-table-info  ## volume mount path for table info inside cronjob container
    - name: kernel
      enabled: true
      container_volume_path: /kernek-table-info  ## volume mount path for table info inside cronjob container
    - name: master
      enabled: true
      container_volume_path: /master-table-info  ## volume mount path for table info inside cronjob container
    - name: pms
      enabled: false
      container_volume_path: /pms-table-info  ## volume mount path for table info inside cronjob container
    - name: regprc
      enabled: false
      container_volume_path: /regprc-table-info  ## volume mount path for table info inside cronjob container
    - name: resident
      enabled: false
      container_volume_path: /resident-table-info  ## volume mount path for table info inside cronjob container
```
Each entry includes a name and an enabled flag to indicate if the database should be included in the archival process.

## Adding Another Database

To add another database to the archival list, follow these steps:

1. Update the `values.yaml` file.

2. Under the `db_names` section, add a new entry with the following format:

   ```yaml
   - name: new_database_name
     enabled: true  # or false, depending on whether you want to include it
   ```
3. Replace `new_database_name` with the desired name of the new database.
4. Save the changes to the `values.yaml` file.

### Source Database Connections (source_db)

For each source database (audit, credential, esignet, ida, idrepo, kernel, master, pms, prereg, regprc, resident), provide the following information:

- `source_<database>_host`: Source database host.
- `source_<database>_port`: Port number for the source database connection.
- `source_<database>_uname`: Source database username.
- `source_<database>_dbname`: Source database name.
- `source_<database>_schemaname`: Source schema name.
- `source_<database>_db_pass`: Password for the source database.




## Container Volume Path
container_volume_path: Path where JSON files containing information about all databases will be stored

## Archiving Information (all_db_tables_info)

For each database, specify tables_info with details for archiving. Example:

```yaml
audit:
  tables_info:
    - source_table: "app_audit_log"
      archive_table: "mosip_audit_app_audit_log"
      id_column: "log_id"
      date_column: "log_dtimes"
      retention_days: 30
      operation_type: "archive_delete"
```
`source_table`: Name of the table in the source database.
`archive_table`: Name of the table in the archive database.
`id_column`: Column representing the unique identifier.
`date_column`: Column representing the date of the record.
`retention_days`: Number of days to retain the archived data.
`operation_type`: Type of operation for archiving (e.g., archive_delete, delete, none).
- `delete`: Delete records from the source table.
- `archive_delete`: Archive records to an archive table and then delete them from the source table.
- `none`: Skip archival for the specified table.
