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
from common import *
from logger import init_logger
from db import set_packet_retry_count, get_invalid_packets

HOST='localhost'

logger = logging.getLogger() # Root Logger 

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
    logger.info('Uploading packet %s to secure zone' % rid)
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
    logger.info('HTTP response = %s' %  r.status_code)

    return r

def reprocess_packet(rid, cur, host):
    '''
    Assumes rid.zip is present in archival folder
    Args:
        rid: Reg Id
        cur: Cursor of mosip_regprc DB
    '''
    # Move packet from archival zone back to landing zone  
    logger.info('Moving packet %s to landing zone' % rid)
    zip_src = os.path.join(PACKET_ARCHIVAL, (rid + '.zip'))
    zip_dst = os.path.join(PACKET_LANDING, (rid + '.zip')) 
    if not os.path.exists(zip_src) and not os.path.exists(zip_dst):
        return 1  # Error

    if not os.path.exists(zip_dst):
        shutil.move(zip_src, zip_dst)

    set_packet_retry_count(rid, 0, cur)

    upload_packet_to_secure_zone(host, rid)

    return 0

def main():
    global logger

    init_logger(logger, 'logs/reprocess.log', 10000000, 'info', 1)

    conn = psycopg2.connect("dbname=mosip_regprc user=postgres")
    conn.autocommit = True
    cur = conn.cursor() 
    rids = get_invalid_packets(cur)
    logger.info('Total invalid packets = %s' % len(rids)) 
    logger.info('Invalid packets = %s' %  rids)
    for rid in rids:
        logger.info('reprocessing %s' % rid)
        err = reprocess_packet(rid, cur, HOST)
        if err:
            logger.error('Packet %s.zip not found' % rid)
   
if __name__== '__main__':
    main()
