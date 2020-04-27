import json
import requests
import os
import datetime as dt
#from Crypto.Cipher import AES
#from Crypto.PublicKey import RSA
#from Crypto.Cipher import PKCS1_v1_5 as Cipher_PKCS1_v1_5
import base64
import hashlib
import shutil
import subprocess
import logging
import csv
import datetime as dt
import hashlib

logger = logging.getLogger(__name__)

class UserInfo:
    def __init__(self):
        self.uid= None
        self.user_name = None
        self.user_password = None
        self.user_email = None
        self.user_mobile = None
        self.machine_mac = None
        self.machine_name = None
        self.center_id = None
        self.role = None  # Roles as in LDAP
        self.zone_code = None
        self.lang_code = None

def command(cmd):
    r = subprocess.run(cmd, shell=True)
    if r.returncode != 0: 
        logger.error(r)
        
def read_token(response):
    cookies = response.headers['Set-Cookie'].split(';')
    for cookie in cookies:
        key = cookie.split('=')[0]
        value = cookie.split('=')[1]
        if key == 'Authorization':
            return value

    return None

def auth_get_token(appid, username, password, root):
    url = root + '/v1/authmanager/authenticate/useridPwd'
    ts = get_timestamp()
    j = {
        "id": "mosip.io.userId.pwd",
        "metadata" : {},
            "version":"1.0",
            "requesttime": ts, 
            "request": {
                "appId" : appid, 
                "userName": username,
                "password": password
        }
    }
    r = requests.post(url, json = j)
    token = read_token(r) 
    return token 

def get_timestamp(days_offset=None):
    '''
    Current TS.
    Format: 2019-02-14T12:40:59.768Z  (UTC)
    '''
    delta = dt.timedelta(days=0)
    if days_offset is not None:
        delta = dt.timedelta(days=days_offset)
         
    ts = dt.datetime.utcnow() + delta
    ms = ts.strftime('%f')[0:2]
    s = ts.strftime('%Y-%m-%dT%H:%M:%S') + '.%sZ' % ms
    return s 

def generate_machine_id_from_mac(mac, nchars):
    '''
    Args:
        mac: mac address as str (format does not matter)
        nchars: number of chars in id 
    '''

    m = hashlib.md5()
    m.update(mac.encode())
    machine_id = m.hexdigest()[0 : nchars]

    return machine_id
    
def parse_umc_csv(csv_file):
    '''
    User-machine-center mapping is specified in a csv as
    [mac,machine_name,user_name,uid,password,user_email,user_mobile,
     center_id,ldap_role']
    '''
    f = open(csv_file, 'rt')
    reader = csv.reader(f)    
    next(reader, None)  # Skip header row

    user_infos = []
    for row in reader:
        u = UserInfo()
        u.machine_mac = row[0]
        u.machine_name = row[1]
        u.user_name = row[2]
        u.uid = row[3] 
        u.user_password = row[4]
        u.user_email = row[5]
        u.user_mobile = row[6]
        u.center_id = row[7] 
        u.role = row[8] # Currently only one role is assumed. TODO.
        u.zone_code = 'PHIL' # Default, so hardcoded 
        u.lang_code = 'eng' # Default, so hardcoded
        user_infos.append(u)
    return user_infos
def print_response(r):
    print(r.headers)
    print(r.links)
    print(r.encoding)
    print(r.status_code)
    print('Size = %s' % len(r.content))
    print('Response Data = %s' % r.content)

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
