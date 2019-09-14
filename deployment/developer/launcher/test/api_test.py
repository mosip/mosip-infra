#!/usr/bin/python3.6
import json
import requests
import os
import datetime as dt
from Crypto.Cipher import AES
from Crypto.PublicKey import RSA
from Crypto.Cipher import PKCS1_v1_5 as Cipher_PKCS1_v1_5
import base64
import hashlib

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
    Format: 2019-02-14T12:40:59.768Z  (local time)
    '''
    ts = dt.datetime.utcnow()
    ms = ts.strftime('%f')[0:2]
    s = ts.strftime('%Y-%m-%dT%H:%M:%S') + '.%sZ' % ms
    return s 
 
def prereg_send_otp():
    '''
    Add use email id below. 
    '''
    url ='http://localhost:9090/preregistration/v1/login/sendOtp'
    j = {
        "id": "mosip.pre-registration.login.sendotp",
        "version": "1.0",
        "requesttime": "2019-08-28T14:00:47.605Z",
        "request": {
            "userId": "xyz@gmail.com"
        }
    }

    r = requests.post(url, json=j)

    print_response(r)

def read_token(response):
    cookies = response.headers['Set-Cookie'].split(';')
    for cookie in cookies:
        key = cookie.split('=')[0]
        value = cookie.split('=')[1]
        if key == 'Authorization':
            return value

    return None

def auth_get_token(appid, username, password):
    url = 'http://localhost:8191/v1/authmanager/authenticate/useridPwd'
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

def get_public_key(appid, center_id, machine_id, token):
    '''
    Returns:
        Bytes of public key (after base64 decoding)
    '''
    url = 'http://localhost:8188/v1/keymanager/publickey/REGISTRATION'
    cookies = {'Authorization' : token}
    refid = center_id + '_' + machine_id
    r = requests.get(url, params = {'referenceId' : refid,
                                    'timeStamp' : get_timestamp()}, 
                     cookies = cookies)
    r = json.loads(r.content) # Get dict
    publickey = base64.urlsafe_b64decode(r['response']['publicKey']) 
    return publickey

def sync_packet(regid, packet_hash, packet_size, center_id, machine_id, token):
    url = 'http://localhost:8083/registrationprocessor/v1/registrationstatus/sync' 
    cookies = {'Authorization' : token}
    headers = {'Center-Machine-RefId' : center_id,
               'timestamp' : get_timestamp()} 
    j = {
        "id": "mosip.registration.sync",
        "version": "1.0",
        "requesttime": get_timestamp(), 
        "request": [{
            "registrationId": regid, 
            "registrationType": "NEW",
            "packetHashValue": packet_hash, 
            "packetSize": packet_size,
            "supervisorStatus": "APPROVED",
            "supervisorComment": "Approved, all good",
            "langCode": "eng"
        }]
    } 
    r = requests.post(url, json = j, cookies = cookies, headers = headers) 
    print(r)

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
    return m.hexdigest()
 
def encrypt_packet(in_packet_zip, out_packet_zip, publickey):
    '''
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
 
def test_reg_proc():
    '''
    1. First get authorization token (whos?) 
    2. Using keymanager API get public key of center_machine (rid)
    3. Create packet and encrypt using the above public key
    4. Sync Packet
    5. Upload packet
    '''
    token = auth_get_token('registrationprocessor', 'registration_admin',
                            'mosip')
    center_id = '10006'
    machine_id = '10036'
    publickey = get_public_key('REGISTRATION', center_id, machine_id, token)
    regid = '10006100360002120190905051341'
    in_packet_zip = 'data/packet/unencrypted/%s.zip' % regid
    out_packet_zip = '%s.zip' % regid # in current folder

    phash, psize = encrypt_packet(in_packet_zip, out_packet_zip, publickey)

    sync_packet(regid, phash, psize, center_id, machine_id, token)
    
def main():
    #prereg_send_otp()
    test_reg_proc()

if __name__=='__main__':
    main() 

