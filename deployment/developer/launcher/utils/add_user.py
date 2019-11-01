#!/bin/python3.6
# Script to add a user, machine, center combo from a CSV to DB and LDAP. 
# The CSV columns are  mentioned in help.  
# ./add_user.py <csv file>
# 
# CAUTION: If any SQL changes here, make sure it is changed in other places
# as well like resources/sql and vice-a-versa

import sys
import os
import psycopg2
import csv
import ldap
import argparse
sys.path.insert(0, '../')
from common import *
from logger import init_logger
from ldap_utils import add_user_in_ldap
from db import add_umc

logger = logging.getLogger() # Root Logger 

def parse_csv(csv_file):
    f = open(csv_file, 'rt')
    reader = csv.reader(f)    
    next(reader, None)  # Skip header row
    #['1234','F8-B4-6A-B2-0E-59','DESKTOP-A96IHMO','Marie Catherine L. Garilao', 'REG203', 'h@ppyBox24', '10001']

    user_infos = []
    for row in reader:
        u = UserInfo()
        u.machine_id = row[0]
        u.machine_mac = row[1]
        u.machine_name = row[2]
        u.user_name = row[3]
        u.user_id = row[4] 
        u.user_password = row[5]
        u.user_email = row[6]
        u.user_mobile = row[7]
        u.center_id = row[8] 
        user_infos.append(u)
    return user_infos

def parse_args():

    parser = argparse.ArgumentParser(description='Script to add a user to DB and LDAP. If no options are specified attempt is made to add entries into both DB and LDAP. If there is any conflict the insert is skipped, meaning update is NOT done') 
    parser.add_argument('csv', help='csv: machine_id,mac,machine_name,user_name,user_id,password,user_email,user_mobile,center_id')
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

    uinfo = parse_csv(args.csv)
    conn = psycopg2.connect("dbname=mosip_master user=postgres")
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
                logger.info('User already exists in LDAP: %s' % (u.user_id))

    conn.commit()
    conn.close()

if __name__== '__main__':
    main()

