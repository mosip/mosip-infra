#!/bin/sh
# Script to clear identity_schema table in mosip_master db.
# WARNING: all data in table will be erased.
# KNOW WHAT YOU ARE DOING!
# Modify -h host to point to your setup

psql -d mosip_master  -h mzingress.sb -p 30090 -U postgres < sql/regdel.sql
