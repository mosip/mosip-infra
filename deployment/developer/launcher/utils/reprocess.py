#!/bin/python3.6
# This script contains functions to re-process a failed process on the server.
# It is currently assumed that this script be run directly on the sandbox/
# machine. Also, it is advisable to use the reprocessor service for this 
# purpose, however, since for a sandbox we are running limited stages (till
# OSI validation), reprocessor service may give problems.

import sys
import shutil
import psycopg2
sys.path.insert(0, '../')
from config import *
from db import set_packet_retry_count, get_invalid_packets

HOST='localhost'

def upload_packet_to_secure_zone(host, rid):
    '''
    Move a packet from Landing zone to Archival for further processing.  
    This is typically used when for some reason packet validation has failed 
    and you want to retry.
    Before running this call, make sure the packet has been moved back to 
    Landing zone.
    Args:
        host: localhost/ip address of machine 

    '''
    token = auth_get_token('registrationprocessor', 'registrationprocessor',
                            'mosip')
    url = 'http://%s/registrationprocessor/v1/uploader/securezone' % host
    j =  {
       "rid": rid,
       "reg_type" : "NEW",
       "isValid": True,
       "internalError": False,
       "messageBusAddress": None,
       "retryCount": None
    }
    cookies = {'Authorization' : token}
    r = requests.post(url, json=j, cookies=cookies)

    return r

def reprocess_packet(rid, cur, host):
    '''
    Assumes rid.zip is present in archival folder
    Args:
        rid: Reg Id
        cur: Cursor of mosip_regprc DB
    '''
    # Move packet from archival zone back to landing zone  
    zip_loc = os.path.join(PACKET_ARCHIVAL, rid + '.zip')
    shutil.move(zip_loc, PACKET_LANDING) 

    set_packet_retry_count(rid, 0, cur)

    upload_packet_to_secure_zone(host, rid)


def main():
    conn = psycopg2.connect("dbname=mosip_regprc user=postgres")
    cur = conn.cursor() 
    rids = get_invalid_packets(cur)
    for rid in rids:
        reprocess_packet(rid, cur, HOST)
   
if __name__== '__main__':
    main()
