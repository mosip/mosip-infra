## Master data

To load country specific masterdata before you start installing standbox:

1. Make sure the Master Data `.csv` files are available in a folder, say `my_dml`.
1. Add the following line in `group_vars/all.yml` -> `databases` -> `mosip_master`
```
mosip_master:
  sql_path: '{{repos.commons.dest}}/db_scripts'
  dml: 'my_dml/'
```
