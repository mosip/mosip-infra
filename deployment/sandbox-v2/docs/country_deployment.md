# Country Specific Deployment

## Introduction

This guide for modifying the standard sandbox configuration to country specific configuration

## Master data

To update country specific masterdata:

1. Make sure the Master Data `.csv` files are available in a folder, say `my_dml`.
1. Add the following line in `group_vars/all.yml` -> `databases` -> `mosip_master`
```
mosip_master:
  sql_path: '{{repos.commons.dest}}/db_scripts'
  dml: 'my_dml/'
```
1. The above steps be done *before* running the Ansible install scripts.
