#!/bin/python3

import os
import csv
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

def pvt_key(key_path, passphrase):
    key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    fd = open(key_path, 'wb')
    fd.write(key.private_bytes(encoding=serialization.Encoding.PEM,
                               format=serialization.PrivateFormat.TraditionalOpenSSL,
                               encryption_algorithm=serialization.BestAvailableEncryption(passphrase.encode())))
   
    fd.close()

def self_signed_cert(out_path, cn, org_name, country, province, locality, valid_days, pvt_key_path, passphrase):
    '''
    valid_days: Number of valid days from now 
    '''
    private_key = serialization.load_pem_private_key(open(pvt_key_path, 'rb').read(), password=passphrase.encode())
    subject = issuer = x509.Name([
        x509.NameAttribute(NameOID.COUNTRY_NAME, u'%s' % country),
        x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, u'%s' % province),
        x509.NameAttribute(NameOID.LOCALITY_NAME, u'%s' % locality),
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, u'%s' % org_name),
        x509.NameAttribute(NameOID.COMMON_NAME, u'%s' % cn),
    ])
    builder = x509.CertificateBuilder()
    builder = builder.subject_name(subject)
    builder = builder.issuer_name(issuer)
    builder = builder.not_valid_before(dt.datetime.now(dt.timezone.utc) - dt.timedelta(days=1))
    builder = builder.not_valid_after(dt.datetime.now(dt.timezone.utc) + dt.timedelta(days=valid_days))
    builder = builder.serial_number(x509.random_serial_number())
    builder = builder.public_key(private_key.public_key())
    builder = builder.add_extension(x509.BasicConstraints(ca=False, path_length=None), critical=True)
    builder = builder.add_extension(x509.SubjectKeyIdentifier.from_public_key(private_key.public_key()), 
                                    critical=False)
    builder = builder.sign(private_key, hashes.SHA256())
    fd = open(out_path, 'wb')
    fd.write(builder.public_bytes(serialization.Encoding.PEM))
    fd.close()

def root_signed_cert(out_path, cn, org_name, country, province, locality, valid_days, root_cert_path, 
                     root_pvt_key_path, passphrase):
    '''
    valid_days: Number of valid days from now 
    '''
    # First load root cert and keys
    root_private_key = serialization.load_pem_private_key(open(root_pvt_key_path, 'rb').read(), 
                                                          password=passphrase.encode())
    fd = open(root_cert_path, 'rb')
    root_cert = x509.load_pem_x509_certificate(fd.read())
     

    subject = x509.Name([
        x509.NameAttribute(NameOID.COUNTRY_NAME, u'%s' % country),
        x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, u'%s' % province),
        x509.NameAttribute(NameOID.LOCALITY_NAME, u'%s' % locality),
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, u'%s' % org_name),
        x509.NameAttribute(NameOID.COMMON_NAME, u'%s' % cn),
    ])
    builder = x509.CertificateBuilder()
    builder = builder.subject_name(subject)
    builder = builder.issuer_name(root_cert.issuer)
    builder = builder.not_valid_before(dt.datetime.now(dt.timezone.utc) - dt.timedelta(days=1))
    builder = builder.not_valid_after(dt.datetime.now(dt.timezone.utc) + dt.timedelta(days=valid_days))
    builder = builder.serial_number(x509.random_serial_number())
    builder = builder.public_key(private_key.public_key())
    builder = builder.add_extension(x509.BasicConstraints(ca=False, path_length=None), critical=True)
    builder = builder.add_extension(x509.SubjectKeyIdentifier.from_public_key(private_key.public_key()), 
                                    critical=False)
    builder = builder.sign(private_key, hashes.SHA256())
    fd = open(out_path, 'wb')
    fd.write(builder.public_bytes(serialization.Encoding.PEM))
    fd.close()

def main():
    
    reader = csv.DictReader(open(conf.csv_dp, 'rt')) 
    for row in reader:
        #print('Creating self signed certificate for %s' % row['cn'])
        #pvt_key(row['key_path'], row['passphrase'])
        #self_signed_cert(row['cert_path'], row['cn'], row['org_name'], row['country'], row['province'], row['locality'],
        #           int(row['valid_days']), row['key_path'], row['passphrase']) 
        root_signed_cert(row['cert_path'], row['cn'], row['org_name'], row['country'], row['province'], row['locality'],
                   int(row['valid_days']), 'certs/ca1/self_cert.pem', 'certs/ca1/pvt_key.pem', 'abc') 

if __name__=="__main__":
    main()
