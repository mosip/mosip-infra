import json
import requests
import os
import datetime as dt
from Crypto.Cipher import AES
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5 as Cipher_PKCS1_v1_5
import base64
import hashlib
import shutil

def print_response(r):
    print(r.headers)
    print(r.links)
    print(r.encoding)
    print(r.status_code)
    print('Size = %s' % len(r.content))
    print('Response Data = %s' % r.content)
     
def get_timestamp():
    '''
    Current TS.
    Format: 2019-02-14T12:40:59.768Z  (UTC)
    '''
    ts = dt.datetime.utcnow()
    ms = ts.strftime('%f')[0:2]
    s = ts.strftime('%Y-%m-%dT%H:%M:%S') + '.%sZ' % ms
    return s 

def encrypt_packet(in_packet_zip, out_packet_zip, publickey):
    '''
    Encrypt packet without using server. CAUTION: MAY BE BUGGGY
    Returns:
        Packet hash
        Size of packet
    '''
    data = open(in_packet_zip, 'rb').read()
    sym_key = os.urandom(32)  # 32 bytes long random key  
    encrypted, iv = aes_encrypt(data, sym_key)
    encrypted_key = rsa_encrypt(sym_key, publickey)

    # append iv to encrypted packet
    packet = encrypted + iv
    packet = packet + '#KEY_SPLITTER'.encode('utf-8') + encrypted_key

    # HTTP safe base64  encode
    packet = base64.urlsafe_b64encode(packet)

    # Write in file 
    fd = open(out_packet_zip, 'wb')
    fd.write(packet)
    fd.close()

    # Rturn hash of packet
    packet_hash = sha256_hash(packet) 

    return packet_hash, len(packet)

def pad_data(data, block_size):
    '''
    Pad data (bytes) to multiples of block_size bytes and return padded data
    '''
    data = data + bytes(block_size - (len(data) % block_size))
    return data 

def aes_encrypt(data, sym_key):
    '''
    Pads data if needed.  Generates random IV vector and returns the same
    '''
    data = pad_data(data, block_size=16)
    iv = os.urandom(16) # 16 bytes
    obj = AES.new(sym_key, AES.MODE_CBC, iv) 
    encrypted = obj.encrypt(data)
    return encrypted, iv

def rsa_encrypt(data, publickey):
    '''
    publickey in sequence of bytes
    '''
    rsa_key = RSA.importKey(publickey) 
    cipher = Cipher_PKCS1_v1_5.new(rsa_key)
    encrypted = cipher.encrypt(data)
    return encrypted

def sha256_hash(data):
    '''
    data assumed as type bytes
    '''
    m = hashlib.sha256()
    m.update(data)
    h = m.hexdigest().upper()
    return h 
