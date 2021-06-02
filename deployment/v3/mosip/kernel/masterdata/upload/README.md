# Masterdata Upload Utility

It is suggested to not edit the csv files directly. Instead use the xlsx files from the provided directory and "Save as CSV" into the csv directory.

## 1. To bulkupload using api
- ```
  $ export IAM_USERNAME=<username>
  $ export IAM_PASSWORD=<password>
  $ chmod +x bulkupload.py
  $ ./bulkupload.py [path-to-csv-dir] [table-order-file]
  ```
- Make sure to change the first line of `bulkupload.py` to the correct python3 location.
- This will bulkupload all csv files in order of `[table-order-file]` from `[path-to-csv-dir]` according to their file names, using the `/v1/admin/bulkupload` api.

## 2. To bulkupload directly to db using sql

- It is recommended to use the above script in at all cases, unless absolutely required.
- ```
  $ chmod +x bulkupload.py
  $ export IAM_USERNAME=<username>
  $ export DB_USER=<db_username>
  $ export DB_PWD=<db_password>
  $ export DB_HOST=<db_host>
  $ export DB_PORT=<db_port>
  $ export DB_NAME=<db_name>
  $ ./bulkupload_using_sql.py [path-to-csv-dir] [table-order-file]
  ```
- Make sure to change the first line of `bulkupload_using_sql.py` to the correct python3 location.
- This will bulkupload all csv files in order of `[table-order-file]` from `[path-to-csv-dir]` according to their file names, directly to database, using sql "insert".

## 3. Miscellaneous one-time scripts
#### 3.1 csv_del_data.py
- Use this script to delete unwanted data in the csvs, like unwanted rows and columns.
- ```
  $ ./csv_del_data.py [original-csv-dir] [output-empty-csv-dir]
  ```

#### 3.2 csv_to_xlsx.py
- Use this script to convert all csv files from a directory to xlsx files.
- ```
  $ ./csv_to_xlsx.py [original-csv-dir] [output-empty-xlsx-dir]
  ```
