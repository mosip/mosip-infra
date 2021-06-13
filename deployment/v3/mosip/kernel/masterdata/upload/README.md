# Masterdata Upload Utility

## Introduction

It is suggested to not edit the csv files directly. Instead use the xlsx files from the provided directory and "Save as CSV" into the csv directory.

## Prequisites
1. `python3`
1. Install additional modules:
```sh
pip3 install -r requirements.txt
```
1. (Optional) Install [XLS diff utiliy](https://github.com/na-ka-na/ExcelCompare).

## Bulk upload using Admin API
_TODO: The API is still undergoing testing. For now, we recommend upading using [sql directly](#Bulk-upload-using-sql)_
- ```
  $ export IAM_USERNAME=<username>
  $ export IAM_PASSWORD=<password>
  $ chmod +x bulkupload.py
  $ ./bulkupload.py [path-to-csv-dir] [table-order-file]
  ```
- Make sure to change the first line of `bulkupload.py` to the correct python3 location.
- This will bulkupload all csv files in order of `[table-order-file]` from `[path-to-csv-dir]` according to their file names, using the `/v1/admin/bulkupload` api.

## Bulk upload using sql

* Use this script only once initially while seeding the DB.
  ```
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

## Miscellaneous one-time scripts
* `csv_del_data.py`: Use this script to delete unwanted data in the csvs, like unwanted rows and columns.
  ```
  $ ./csv_del_data.py [original-csv-dir] [output-empty-csv-dir]
  ```

* `csv_to_xlsx.py`: Use this script to convert all csv files from a directory to xlsx files.
  ```
  $ ./csv_to_xlsx.py [original-csv-dir] [output-empty-xlsx-dir]
  ```
