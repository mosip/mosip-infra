#!/bin/python3

import os
import csv
import argparse
import datetime as dt
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography import x509
from cryptography.hazmat.primitives import hashes
from cryptography.x509.oid import NameOID
from cryptography.hazmat.backends import default_backend
import config as conf

class Credentials:
    def __init__(self):
        self.pvt_key_path = None
        self.passphrase = None 
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
        self.ca_passphrase = None

def gen_pvt_key(key_path, passphrase):
    key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    fd = open(key_path, 'wb')
    fd.write(key.private_bytes(encoding=serialization.Encoding.PEM,
                               format=serialization.PrivateFormat.TraditionalOpenSSL,
                               encryption_algorithm=serialization.BestAvailableEncryption(passphrase.encode())))
    fd.close()

def create_cert(cred):

    subject = x509.Name([
        x509.NameAttribute(NameOID.COUNTRY_NAME, u'%s' % cred.country),
        x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, u'%s' % cred.province),
        x509.NameAttribute(NameOID.LOCALITY_NAME, u'%s' % cred.locality),
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, u'%s' % cred.org_name),
        x509.NameAttribute(NameOID.COMMON_NAME, u'%s' % cred.cn),
    ])
     
    subject_private_key = serialization.load_pem_private_key(open(cred.pvt_key_path, 'rb').read(), 
                                                        password=cred.passphrase.encode())
    if len(cred.ca_pvt_key_path) == 0: # Self signed
        signing_private_key = subject_private_key
        issuer = subject
    else: # Signed by CA
        signing_private_key = serialization.load_pem_private_key(open(cred.ca_pvt_key_path, 'rb').read(), 
                                                          password=cred.ca_passphrase.encode())
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

def create_certs(csv_file): #CSV row
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        print('Creating certificate for "%s"' % row['cn'])
        cred = Credentials() 
        cred.pvt_key_path = row['key_path']
        cred.passphrase = row['passphrase']
        cred.cert_path = row['cert_path']
        cred.is_ca = True if row['is_ca'] == 'true' else False
        cred.cn = row['cn']
        cred.org_name = row['org_name']
        cred.country = row['country']
        cred.province = row['province']
        cred.locality = row['locality']
        cred.valid_days = int(row['valid_days']) 
        cred.ca_cert_path = row['ca_cert_path']
        cred.ca_pvt_key_path = row['ca_pvt_key_path']
        cred.ca_passphrase = row['ca_passphrase']
    
        os.makedirs(os.path.dirname(cred.pvt_key_path), exist_ok=True)
        os.makedirs(os.path.dirname(cred.cert_path), exist_ok=True)
        gen_pvt_key(cred.pvt_key_path, cred.passphrase)
        create_cert(cred)
  
def main():

    create_certs(conf.csv_certs)

if __name__=="__main__":
    main()
