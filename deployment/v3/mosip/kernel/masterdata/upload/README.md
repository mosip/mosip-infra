## 1. To bulkupload
```
$ chmod +x bulkupload.py
$ ./bulkupload.py [path-to-xlsx-dir] [table-order-file]
```
Make sure to change the first line of `bulkupload.py` to the correct python3 location

This will bulkupload all xlsx files in order of `[table-order-file]` from `[path-to-xlsx-dir]` according to their file names.

This uses the /v1/admin/bulkupload api.
