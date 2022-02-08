#!/bin/python3

import sys
import argparse
from api import *
import json
sys.path.insert(0, '../')
from utils import *

def upload_zk_cert(session, from_app_id, from_ref_id, to_app_id, to_ref_id):
    myprint('Uploading ZK cert')
    myprint('Getting certificate from %s:%s' % (from_app_id, from_ref_id))
    r = session.get_ida_internal_cert(from_app_id, from_ref_id)
    myprint(r)
    if len(r['errors']) != 0:
        myprint('ABORTING')
        return 1 
    cert = r['response']['certificate']

    # Upload
    myprint('Uploading cert to keymanager %s:%s' % (to_app_id, to_ref_id))
    r = session.upload_other_domain_cert(cert, to_app_id, to_ref_id)
    myprint(r)
    if r['errors'] is not None:
        myprint('ABORTING')
        return 1 
    return 0

# Fetch cert from IDA and upload via partner management
def upload_ca_cert(session, app_id, ref_id=None):
    # Get IDA root
    myprint('Fetching %s cert' % app_id)
    r = session.get_ida_internal_cert(app_id, ref_id)
    myprint(r)
    if len(r['errors']) != 0:
        myprint('ABORTING')
        return 1 
    cert = r['response']['certificate']

    # Upload IDA Root as CA cert for IDA partner
    myprint('Uploading %s as CA cert' % app_id)
    r = session.upload_ca_certificate(cert, 'AUTH')
    myprint(r)

def upload_partner_cert(session, partner_id, app_id, ref_id=None):
    myprint('Fetching partner cert for %s:%s' % (app_id, partner_id))
    r = session.get_ida_internal_cert(app_id, ref_id)
    myprint(r)
    if len(r['errors']) != 0:
        myprint('ABORTING')
        return 1 
    cert = r['response']['certificate']

    myprint('Uploading partner cert for %s' % app_id)
    r = session.upload_partner_certificate(cert, 'AUTH', partner_id)
    myprint(r)

def upload_to_keymanager(session, partner_id):
    myprint('Getting mosip signed certificate for partner %s' % partner_id) 
    r = session.get_partner_cert(partner_id)
    myprint(r)
    if len(r['errors']) != 0:
        myprint('ABORTING')
        return 1 
    cert = r['response']['certificateData']

    myprint('Uploading signed cert for %s as Other domain cert' % partner_id)
    r = session.upload_other_domain_cert_to_keymanager('PARNTER', partner_id, cert)
    myprint(r)
    # TODO:  The signed cert should be uploaded to IDA as well.

def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server', type=str, help='Full url to point to the server')
   parser.add_argument('client', type=str, help='IDA client in keycloak - mosip-ida-client')
   parser.add_argument('client_pwd', type=str, help='Password for client')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse() 

    ssl_verify = True
    if args.disable_ssl_verify:
        ssl_verify = False

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode

    try:
        session = MosipSession(args.server, args.client, args.client_pwd, 'ida', ssl_verify=ssl_verify)

        upload_zk_cert(session, 'IDA', 'CRED_SERVICE', 'IDA', 'PUBLIC_KEY')
        upload_ca_cert(session, 'ROOT')
        upload_ca_cert(session, 'IDA')
        upload_partner_cert(session, 'mpartner-default-auth', 'IDA', 'mpartner-default-auth')
        upload_to_keymanager(session, 'mpartner-default-auth')

    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    return sys.exit(0)

if __name__=="__main__":
    main()
