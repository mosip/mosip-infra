#!/bin/python3.6
# This scripts shows status of rid from registration table, registration_transaction table and packet store.
# Usage (example):
# python rid_status.py <file with rids in each row> 

import psycopg2
import sys
sys.path.insert(0, '../')
from config import *
from datetime import datetime
import os

def find_path(name, path):
    # search for a name in the path if found prints path of it.
    for root, dirs, files in os.walk(path):
        if (name+'.zip') in files:
            print('path of file: '+name+' is: ' + os.path.join(root, name))

def fetch_values(dbname, rid):
    # fetches status of packet for rid by checking registration and registration_transaction table
    conn = psycopg2.connect("dbname=%s user=postgres" % dbname)
    cur = conn.cursor()

    print('\n'+'id : ' + rid)
    cur.execute("select id, cr_dtimes, status_comment from registration where id = '%s';" % rid)
    result = cur.fetchall()
    print('-------------------registration Table--------------------')
    for row in result:
        print(row[0], row[2], datetime.strftime(row[1], '%m/%d/%y %H:%M:%S'))

    cur.execute("select reg_id, status_comment, cr_dtimes from registration_transaction where reg_id = '%s';" % rid)
    result = cur.fetchall()
    print('-------------------registration Transaction--------------------')
    for row in result:
        print(row[0], row[1], datetime.strftime(row[2], '%m/%d/%y %H:%M:%S'))

    cur.close()
    conn.close()

    print('--------PATH--------')
    find_path(rid, PACKET_ARCHIVAL)
    find_path(rid, PACKET_LANDING)

def read_file(filename, dbname):
    # read list of rid from filename
    print("dbname=%s user=postgres" % dbname)
    with open(filename, 'rt') as fd:
        rids = fd.readlines()
        for rid in rids:
            rid = rid.strip()
            fetch_values(dbname, rid)


if __name__== '__main__':
    read_file(sys.argv[1], 'mosip_regprc')
