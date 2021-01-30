#!/bin/python3

import os
import argparse
import datetime as dt
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.x509.oid import NameOID
from cryptography.hazmat.backends import default_backend
import config as conf
from api import *

class Credentials:
    def __init__(self):
        self.pvt_key_path = None
        self.cert_path = None
        self.is_ca = None # Is the subject a CA.
        self.cn = None # Common Name
        self.org_name = None
        self.country = None
        self.province = None
        self.locality = None
        self.valid_days = None
        self.ca_cert_path = None  
        self.ca_pvt_key_path = None

def gen_pvt_key(key_path):
    key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    fd = open(key_path, 'wb')
    fd.write(key.private_bytes(encoding=serialization.Encoding.PEM,
                               format=serialization.PrivateFormat.TraditionalOpenSSL,
                               encryption_algorithm=serialization.NoEncryption()))
    fd.close()

def create_cert(cred):

    subject = x509.Name([
        x509.NameAttribute(NameOID.COUNTRY_NAME, u'%s' % cred.country),
        x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, u'%s' % cred.province),
        x509.NameAttribute(NameOID.LOCALITY_NAME, u'%s' % cred.locality),
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, u'%s' % cred.org_name),
        x509.NameAttribute(NameOID.COMMON_NAME, u'%s' % cred.cn),
    ])
     
    subject_private_key = serialization.load_pem_private_key(open(cred.pvt_key_path, 'rb').read(), password=None)
    if len(cred.ca_pvt_key_path) == 0: # Self signed
        signing_private_key = subject_private_key
        issuer = subject
    else: # Signed by CA
        signing_private_key = serialization.load_pem_private_key(open(cred.ca_pvt_key_path, 'rb').read(), password=None) 
        ca_cert = x509.load_pem_x509_certificate(open(cred.ca_cert_path, 'rb').read())
        issuer = ca_cert.issuer 

    builder = x509.CertificateBuilder()
    builder = builder.subject_name(subject)
    builder = builder.issuer_name(issuer)
    builder = builder.not_valid_before(dt.datetime.now(dt.timezone.utc) - dt.timedelta(days=1))
    builder = builder.not_valid_after(dt.datetime.now(dt.timezone.utc) + dt.timedelta(days=cred.valid_days))
    builder = builder.serial_number(x509.random_serial_number())
    builder = builder.public_key(subject_private_key.public_key())
    builder = builder.add_extension(x509.BasicConstraints(ca=cred.is_ca, path_length=None), critical=True)
    builder = builder.add_extension(x509.SubjectKeyIdentifier.from_public_key(subject_private_key.public_key()), 
                                    critical=False)
    builder = builder.sign(signing_private_key, hashes.SHA256())
    fd = open(cred.cert_path, 'wb')
    fd.write(builder.public_bytes(serialization.Encoding.PEM))
    fd.close()

def create_certs(files):
    files = order_certs(files)  # CAs first 
    for f in files:
        j = json.load(open(f, 'rt'))
        cert_path = j['cert_path']
        if os.path.exists(cert_path) ==  True and j['overwrite'] == False:  # skip
            continue
        print('Creating certificate for "%s"' % j['cn'])
        
        # Get CA details
        ca_cert_path = '' # Init
        ca_pvt_key_path = ''
        if len(j['ca_cert'].strip()) > 0: # if ca specified
            ca = json.load(open(j['ca_cert'], 'rt'))
            ca_cert_path = ca['cert_path']
            ca_pvt_key_path = ca['key_path']
             
        cred = Credentials() 
        cred.pvt_key_path = j['key_path']
        cred.cert_path = j['cert_path']
        cred.is_ca = j['is_ca']
        cred.cn = j['cn']
        cred.org_name = j['org_name'] # Must match partner name
        cred.country = j['country']
        cred.province = j['province']
        cred.locality = j['locality']
        cred.valid_days = j['valid_days'] 
        cred.ca_cert_path = ca_cert_path
        cred.ca_pvt_key_path = ca_pvt_key_path
    
        os.makedirs(os.path.dirname(cred.pvt_key_path), exist_ok=True)
        os.makedirs(os.path.dirname(cred.cert_path), exist_ok=True)
        gen_pvt_key(cred.pvt_key_path)
        create_cert(cred)

def get_internal_cert(files):
    '''
    Fetch certificates already generated within mosip system. 
    '''
    session = MosipSession(conf.server, conf.ida_client_id, conf.ida_client_pwd, ssl_verify=conf.ssl_verify, 
                           client_token=True)
    for f in files:
        j  = json.load(open(f, 'rt'))
        if j['module'] != 'ida':  # We only have IDA pull certificate API as of now
           continue
        ref_id = j['ref_id']
        app_id = j['app_id']
        myprint('Getting certificate from %s:%s' % (app_id, ref_id))
        r = session.get_ida_internal_cert(app_id, ref_id)
        myprint(r)
        if len(r['errors']) != 0:
            myprint('ABORTING')
            return 1 
        cert = r['response']['certificate']
        cert_path = j['cert_path']
        os.makedirs(os.path.dirname(cert_path), exist_ok=True)
        fd = open(cert_path, 'wb')
        fd.write(cert.encode())
        fd.close()

def order_certs(files):
    '''
    Order the input cert files based on which ones need to be created first based on interdepedencies.
    '''
    first, second, third = [], [], []
    for f in files:
        j = json.load(open(f, 'rt'))
        ca_path = j['ca_cert'].strip()
        if j['is_ca'] and ca_path: # root cert
            first.append(f)
        elif j['is_ca'] and not ca_path: # dependent root cert
            second.append(f)
        else:
            third.append(f)
    ordered = first + second + third
    return ordered
   
def get_file_type(f):
    j = json.load(open(f, 'rt'))
    return j['type']

def args_parse(): 
   parser = argparse.ArgumentParser()

   parser.add_argument('path', help='directory or file containing cert specification json')
   parser.add_argument('--server', type=str, help='Full url to point to the server.  Setting this overrides server specified in config.py')
   parser.add_argument('--disable_ssl_verify', help='Disable ssl cert verification while connecting to server', action='store_true')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse() 

    if args.server:
        conf.server = args.server   # Overide

    if args.disable_ssl_verify:
        conf.ssl_verify = False

    files = path_to_files(args.path)

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode
    init_logger('last', 'w', './last.log', level=logging.INFO, stdout=False)  # Just record log of last run

    generated_files = [f for f in files if get_file_type(f) == 'generated']
    internal_files = [f for f in files if get_file_type(f) == 'internal']

    create_certs(generated_files)
    get_internal_cert(internal_files)

if __name__=="__main__":
    main()
