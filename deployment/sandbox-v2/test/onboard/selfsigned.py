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
        self.cn = None
        self.org_name = None
        self.country = None
        self.province = None
        self.locality = None
        self.valid_days = None
        self.is_ca = False  # Is Certificate Authority

def pvt_key(key_path, passphrase):
    key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    fd = open(key_path, 'wb')
    fd.write(key.private_bytes(encoding=serialization.Encoding.PEM,
                               format=serialization.PrivateFormat.TraditionalOpenSSL,
                               encryption_algorithm=serialization.BestAvailableEncryption(passphrase.encode())))
    fd.close()

def create_self_signed_cert(cred):
    '''
    cred:  Credentials structure (class)
    '''
    private_key = serialization.load_pem_private_key(open(cred.pvt_key_path, 'rb').read(), 
                                                     password=cred.passphrase.encode())
    subject = issuer = x509.Name([
        x509.NameAttribute(NameOID.COUNTRY_NAME, u'%s' % cred.country),
        x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, u'%s' % cred.province),
        x509.NameAttribute(NameOID.LOCALITY_NAME, u'%s' % cred.locality),
        x509.NameAttribute(NameOID.ORGANIZATION_NAME, u'%s' % cred.org_name),
        x509.NameAttribute(NameOID.COMMON_NAME, u'%s' % cred.cn),
    ])
    builder = x509.CertificateBuilder()
    builder = builder.subject_name(subject)
    builder = builder.issuer_name(issuer)
    builder = builder.not_valid_before(dt.datetime.now(dt.timezone.utc) - dt.timedelta(days=1))
    builder = builder.not_valid_after(dt.datetime.now(dt.timezone.utc) + dt.timedelta(days=cred.valid_days))
    builder = builder.serial_number(x509.random_serial_number())
    builder = builder.public_key(private_key.public_key())
    builder = builder.add_extension(x509.BasicConstraints(ca=cred.is_ca, path_length=None), critical=True)
    builder = builder.add_extension(x509.SubjectKeyIdentifier.from_public_key(private_key.public_key()), 
                                    critical=False)
    builder = builder.sign(private_key, hashes.SHA256())
    fd = open(cred.cert_path, 'wb')
    fd.write(builder.public_bytes(serialization.Encoding.PEM))
    fd.close()

def root_signed_cert(out_path, cn, org_name, country, province, locality, valid_days, self_cred, root_cred):
    '''
    self_cred: Credentials strucutre of subject (whos certificate is being created)  
    root_cred:  Credentials strucutre for root certificate (see Class definition above)
    valid_days: Number of valid days from now 
    '''
    # First load root cert and keys
    root_private_key = serialization.load_pem_private_key(open(root_cred.pvt_key_path, 'rb').read(), 
                                                          password=root_cred.passphrase.encode())
    fd = open(root_cred.cert_path, 'rb')
    root_cert = x509.load_pem_x509_certificate(fd.read())
    fd.close()

    self_private_key = serialization.load_pem_private_key(open(self_cred.pvt_key_path, 'rb').read(), 
                                                          password=self_cred.passphrase.encode())


     
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
    builder = builder.public_key(self_private_key.public_key())
    builder = builder.add_extension(x509.BasicConstraints(ca=cred.is_ca, path_length=None), critical=True)
    builder = builder.add_extension(x509.SubjectKeyIdentifier.from_public_key(self_private_key.public_key()), 
                                    critical=False)
    builder = builder.sign(root_private_key, hashes.SHA256())
    fd = open(self_cred.cert_path, 'wb')
    fd.write(builder.public_bytes(serialization.Encoding.PEM))
    fd.close()

def create_ca_cert(csv_file):
    reader = csv.DictReader(open(csv_file, 'rt')) 
    for row in reader:
        print('Creating self signed CA certificate for "%s"' % row['cn'])
        ca_cred = Credentials() 
        ca_cred.pvt_key_path = row['key_path']
        ca_cred.passphrase = row['passphrase']
        ca_cred.cert_path = row['cert_path']
        ca_cred.cn = row['cn']
        ca_cred.org_name = row['org_name']
        ca_cred.country = row['country']
        ca_cred.province = row['province']
        ca_cred.locality = row['locality']
        ca_cred.valid_days = int(row['valid_days']) 
        ca_cred.is_ca = True  # Is Certificate Authority
        os.makedirs(os.path.dirname(ca_cred.pvt_key_path), exist_ok=True)
        os.makedirs(os.path.dirname(ca_cred.cert_path), exist_ok=True)
        pvt_key(ca_cred.pvt_key_path, ca_cred.passphrase)
        create_self_signed_cert(ca_cred)

def main():
    create_ca_cert(conf.csv_ca)

        #self_signed_cert(row['cert_path'], row['cn'], row['org_name'], row['country'], row['province'], row['locality'],
        #           int(row['valid_days']), row['key_path'], row['passphrase']) 
        #root_signed_cert(row['cert_path'], row['cn'], row['org_name'], row['country'], row['province'], row['locality'],
        #           int(row['valid_days']), 'certs/ca1/self_cert.pem', 'certs/ca1/pvt_key.pem', 'abc') 

if __name__=="__main__":
    main()
