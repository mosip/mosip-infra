#!/bin/sh
# Script to query transaction table
psql -d mosip_regprc -h mzworker0.sb -p 30090 -U postgres < sql/trans.sql
