#!/bin/python3

import sys
import argparse
from api import *
import json
sys.path.insert(0, '../')
from utils import *

def fetch_root_cert(app_id, session):
    r = session.fetch_root_cert(app_id)
    return r['response']['certificate']
    
def args_parse(): 
   parser = argparse.ArgumentParser()
   parser.add_argument('server', type=str, help='Full url to point to the server')
   parser.add_argument('path', help='File containing input data json')
   parser.add_argument('user', type=str, help='User with PARTNER and PARTNERMANAGER role')
   parser.add_argument('user_pwd', type=str, help='Password for user')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse() 

    ssl_verify = True
    if args.disable_ssl_verify:
        ssl_verify = False

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode

    j = json.load(open(args.path, 'rt'))
    try:
        session = MosipSession(args.server, args.user, args.user_pwd, 'partner', ssl_verify=ssl_verify)
        r = session.add_partner(j['name'], j['contact'], j['address'], j['email'], j['id'], j['partner_type'], 
                                j['policy_group'])
        myprint(r)

        # Upload certs. First CA
        ca_cert = j['cert']['ca_cert']
        myprint('Uploading CA certificate "%s"' % ca_cert)
        cert_data = open(ca_cert, 'rt').read()
        r = session.upload_ca_certificate(cert_data, j['partner_domain'])
        myprint(r)

        # Upload partner cert
        base_path = j['cert']['output']['folder']
        cert_path = os.path.join(base_path, j['cert']['output']['cert'])
        cert_data = open(cert_path, 'rt').read()
        r = session.upload_partner_certificate(cert_data, j['name'], j['partner_domain'], j['id'], j['partner_type'])
        myprint(r)
        mosip_signed_cert_path = os.path.join(base_path, 'mosip_signed_cert.pem')
        if r['errors'] is None:
            mosip_signed_cert = r['response']['signedCertificateData']
            open(mosip_signed_cert_path, 'wt').write(mosip_signed_cert)
            myprint('MOSIP signed certificate saved as %s' % mosip_signed_cert_path)

        # Upload MOSIP ROOT and PMS cert. TODO: this is temporary workaround that will be fixed in LTS version
        cert = fetch_root_cert('ROOT', session)    
        r = session.upload_ca_certificate(cert, j['partner_domain'])
        myprint(r)

        cert = fetch_root_cert('PMS', session)    
        r = session.upload_ca_certificate(cert, j['partner_domain'])
        myprint(r)

    except:
        formatted_lines = traceback.format_exc()
        myprint(formatted_lines)
        sys.exit(1)

    return sys.exit(0)

if __name__=="__main__":
    main()
