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
from OpenSSL import crypto
import config as conf
from api import *

class Cert:
    def __init__(self):
        self.pvt_key_path = None  # output 
        self.cert_path = None # output 
        self.is_ca = None # Is the subject a CA.
        self.cn = None # Common Name
        self.org_name = None
        self.country = None
        self.province = None
        self.locality = None
        self.valid_days = None
        self.ca_cert_path = None # input   
        self.ca_pvt_key_path = None # input
 
    def pem_to_p12(self, passphrase):
        print('Creating p12 store')
        p12 = crypto.PKCS12()
        pem = crypto.load_privatekey(crypto.FILETYPE_PEM, open(self.pvt_key_path, 'rb').read())
        p12.set_privatekey(pem)
        fpath = self.pvt_key_path
        dirname = os.path.dirname(fpath)
        fname = os.path.basename(fpath)
        p12_name = fname.split('.')[0] + '.p12'
        p12_path = os.path.join(dirname, p12_name)
        s = p12.export(passphrase=passphrase.encode())
        fd = open(p12_path, 'wb')
        fd.write(s) 
        fd.close()

    def gen_pvt_key(self, passphrase='1234'):
        key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        fd = open(self.pvt_key_path, 'wb')
        fd.write(key.private_bytes(encoding=serialization.Encoding.PEM,
                                   format=serialization.PrivateFormat.TraditionalOpenSSL,
                                   encryption_algorithm=serialization.NoEncryption()))
        fd.close()
        self.pem_to_p12(passphrase)
        
    def create_cert(self):
        subject = x509.Name([
            x509.NameAttribute(NameOID.COUNTRY_NAME, u'%s' % self.country),
            x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, u'%s' % self.province),
            x509.NameAttribute(NameOID.LOCALITY_NAME, u'%s' % self.locality),
            x509.NameAttribute(NameOID.ORGANIZATION_NAME, u'%s' % self.org_name),
            x509.NameAttribute(NameOID.COMMON_NAME, u'%s' % self.cn),
        ])
         
        subject_private_key = serialization.load_pem_private_key(open(self.pvt_key_path, 'rb').read(), password=None)
        if len(self.ca_pvt_key_path) == 0: # Self signed
            signing_private_key = subject_private_key
            issuer = subject
        else: # Signed by CA
            signing_private_key = serialization.load_pem_private_key(open(self.ca_pvt_key_path, 'rb').read(), password=None) 
            ca_cert = x509.load_pem_x509_certificate(open(self.ca_cert_path, 'rb').read())
            issuer = ca_cert.subject
    
        builder = x509.CertificateBuilder()
        builder = builder.subject_name(subject)
        builder = builder.issuer_name(issuer)
        builder = builder.not_valid_before(dt.datetime.now(dt.timezone.utc) - dt.timedelta(days=1))
        builder = builder.not_valid_after(dt.datetime.now(dt.timezone.utc) + dt.timedelta(days=self.valid_days))
        builder = builder.serial_number(x509.random_serial_number())
        builder = builder.public_key(subject_private_key.public_key())
        builder = builder.add_extension(x509.BasicConstraints(ca=self.is_ca, path_length=None), critical=True)
        builder = builder.add_extension(x509.SubjectKeyIdentifier.from_public_key(subject_private_key.public_key()), 
                                        critical=False)
        builder = builder.sign(signing_private_key, hashes.SHA256())
        fd = open(self.cert_path, 'wb')
        fd.write(builder.public_bytes(serialization.Encoding.PEM))
        fd.close()

def parse_json(json_file):
    parsed_j = json.load(open(json_file, 'rt'))
    org_name = parsed_j['name']
    j = parsed_j['cert']
    cert_path = j['generated_cert_path']
    if os.path.exists(cert_path):
        goahead = input('Cert already exists. Overwrite? (Y/n) ')
        if goahead != 'Y':
            return None            

    # Get CA details
    ca_cert_path = '' # Init
    ca_pvt_key_path = ''
    if len(j['ca_cert'].strip()) > 0: # if ca specified
        ca_cert_path = j['ca_cert']
        ca_pvt_key_path = j['ca_pvt_key']
         
    cred = Cert()
    cred.pvt_key_path = j['generated_key_path']
    cred.cert_path = cert_path
    cred.is_ca = j['is_ca']
    cred.cn = j['cn']
    cred.org_name = org_name
    cred.country = j['country']
    cred.province = j['province']
    cred.locality = j['locality']
    cred.valid_days = j['valid_days'] 
    cred.ca_cert_path = ca_cert_path
    cred.ca_pvt_key_path = ca_pvt_key_path

    return cred

def generate_cert(json_file):
    cred = parse_json(json_file)  
    if cred is None:
        return 
    print('Creating certificate for "%s"' % cred.cn)
    os.makedirs(os.path.dirname(cred.pvt_key_path), exist_ok=True)
    os.makedirs(os.path.dirname(cred.cert_path), exist_ok=True)
    
    cred.gen_pvt_key()
    print('Private key created: %s' % cred.pvt_key_path)

    cred.create_cert()
    print('Cert created: %s' % cred.cert_path)

def args_parse(): 
   parser = argparse.ArgumentParser()

   parser.add_argument('path', help='JSON file containing cert specification')
   args = parser.parse_args()
   return args, parser

def main():
    args, parser =  args_parse() 

    init_logger('full', 'a', './out.log', level=logging.INFO)  # Append mode
    
    json_file = args.path

    generate_cert(json_file) 

if __name__=="__main__":
    main()
