#!/bin/python3.6
# This scripts shows status of rid from regiatration table, registration_transaction table and packet store.
# Usage (example):
# python rid_status.py list_of_rid
import psycopg2
import sys
from datetime import datetime
import os

def findPath(name, path):
    # search for a name in the path if found prints path of it.
    for root, dirs, files in os.walk(path):
        if (name+'.zip') in files:
            print('path of file: '+name+' is: ' + os.path.join(root, name))

def fetch_values(dbname, id):
    # fetches status of packet for id by checking registration and registration_transaction table
    conn = psycopg2.connect("dbname=%s user=postgres" % dbname)
    cur = conn.cursor()

    print('\n'+'id : '+id)
    cur.execute("select id, cr_dtimes, status_comment from registration where id = '%s';" % id)
    result = cur.fetchall()
    print('-------------------registration Table--------------------')
    for row in result:
        print(row[0], row[2], datetime.strftime(row[1], '%m/%d/%y %H:%M:%S'))

    cur.execute("select reg_id, status_comment, cr_dtimes from registration_transaction where reg_id = '%s';" % id)
    result = cur.fetchall()
    print('-------------------registration Transaction--------------------')
    for row in result:
        print(row[0], row[1], datetime.strftime(row[2], '%m/%d/%y %H:%M:%S'))

    cur.close()
    conn.close()

    print('--------PATH--------')
    findPath(id, '/home/pmosip/mosip/packet_store/ARCHIVE_PACKET_LOCATION')
    findPath(id, '/home/pmosip/mosip/packet_store/LANDING_ZONE')

def read_file(filename, dbname):
    # read list of rid from filename
    print("dbname=%s user=postgres" % dbname)
    with open(filename, 'r') as file:
        data = list(file.read().split("\n"))
        for row in data:
            fetch_values(dbname, row)

if __name__== '__main__':
    read_file(sys.argv[1], 'mosip_regprc')