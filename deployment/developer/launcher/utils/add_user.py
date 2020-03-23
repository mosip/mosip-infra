#!/bin/python3.6
# Script to add a user, machine, center combo from a CSV to DB and LDAP. 
# The CSV columns are  mentioned in help.  
# ./add_user.py <csv file>
# 
# CAUTION: If any SQL changes here, make sure it is changed in other places
# as well like resources/sql and vice-a-versa
# TODO: Add unique MAC address constraint while adding record to machine_master

import sys
import os
import psycopg2
import csv
import ldap
import argparse
sys.path.insert(0, '../')
from common import *
from logger import init_logger
from ldap_utils import add_user_in_ldap, add_user_to_role
from db import add_umc

logger = logging.getLogger() # Root Logger 

def parse_args():

    parser = argparse.ArgumentParser(description='Script to add a user to DB and LDAP. If no options are specified attempt is made to add entries into both DB and LDAP. If there is any conflict the insert is skipped, meaning update is NOT done') 
    parser.add_argument('csv', help='csv: mac,machine_name,user_name,uid,password,user_email,user_mobile,center_id,ldap_role')
    parser.add_argument('--only-ldap', action='store_true', help='Update only LDAP')
    parser.add_argument('--only-db', action='store_true', help='Update only DB') 
    return parser

def main():
    global logger

    parser = parse_args()
    args = parser.parse_args()
    update_db = True 
    update_ldap = True 
    if args.only_db:
        update_ldap = False
    if args.only_ldap:
        update_db = False
   
    init_logger(logger, 'logs/add_user.log', 10000000, 'info', 1)

    uinfo = parse_umc_csv(args.csv)
    conn = psycopg2.connect("dbname=mosip_master user=postgres")
    conn.autocommit = True
    cur = conn.cursor() 

    ld = ldap.initialize('ldap://localhost:10389')
    ld.bind('uid=admin,ou=system', 'secret')

    for u in uinfo:
        if update_db:
            add_umc(u, cur)

        if update_ldap:
            try:
                add_user_in_ldap(u, ld)
            except ldap.ALREADY_EXISTS: 
                logger.info('User already exists in LDAP: %s' % (u.uid))
            try:
                add_user_to_role(u.uid, u.role, ld)
            except ldap.TYPE_OR_VALUE_EXISTS:
                logger.info('User-Role already in LDAP: %s-%s' % (u.uid, u.role))

    conn.commit()
    conn.close()

if __name__== '__main__':
    main()

