#!/bin/python3
# Cleans up DBs and gets them to original state that existed after init

from db import *

PG_USER = 'postgres'
PG_PWD = ''
PG_HOST = 'mzworker0.sb'
PG_PORT = 30090 

def delete_tables(db_name, tables):
    db = DB(PG_USER, PG_PWD, PG_HOST, PG_PORT, db_name)
    print('%s:' % db_name)
    db.delete(tables)
    db.close()

# PMS
tables = [
    'partner_policy_bioextract',
    'partner_policy',
    'auth_policy',
    'auth_policy_h',
    'misp_license',
    'misp',
    'partner_policy_request',
    'partner',
    'partner_h',
    'policy_group'
]
delete_tables('mosip_pms', tables)
print('')

# KEYMGR
tables = [
    'ca_cert_store',
    'partner_cert_store',
]
delete_tables('mosip_keymgr', tables)
