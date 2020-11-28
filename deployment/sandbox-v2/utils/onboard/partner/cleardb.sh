#!/bin/sh
# Script to clear tables related to these scripts in mosip_pms table.
# Note that tables updated in `mosip_keymgr` for certificates, are not cleared
# here.
# WARNING: all data in several tables will be erased.
# KNOW WHAT YOU ARE DOING!

psql -d mosip_pms -h mzworker0.sb -p 30090 -U postgres < sql/regdel.sql
