#!/usr/bin/python3
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
import sys
from test_common import *
from common import *

ROOT_URL = 'http://mzworker0:30080'  # Ingress
DMZ_URL = 'http://dmzworker0:30080'

def get_regid(center_id, machine_id, serial_number):
    '''
    Generate a 29 character regid
    Args:
        center_id: str
        machine_id: str
        serial_number: int.  Any running number to distinguish packets

    Returns: regid and timestamp
    '''
    ts = dt.datetime.utcnow().strftime('%Y%m%d%H%M%S')
    regid = '%5s%5s%05d%s' % (center_id, machine_id, serial_number, ts)
    return regid, ts
 
def prereg_send_otp():
    '''
    Add use email id below. 
    '''
    url = ROOT_URL + '/preregistration/v1/login/sendOtp'
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

def validate_token(token):
    url = ROOT_URL + '/v1/authmanager/authorize/admin/validateToken'

    cookies = {'Authorization' : token}
    r = requests.get(url, cookies=cookies)
    return r

def get_public_key(appid, center_id, machine_id, token):
    '''
    Returns:
        Bytes of public key (after base64 decoding)
    '''
    url = ROOT_URL + '/v1/keymanager/publickey/REGISTRATION'
    cookies = {'Authorization' : token}
    refid = center_id + '_' + machine_id
    r = requests.get(url, params = {'referenceId' : refid,
                                    'timeStamp' : get_timestamp()}, 
                     cookies = cookies)
    r = json.loads(r.content) # Get dict
    publickey = base64.urlsafe_b64decode(r['response']['publicKey']) 
    return publickey

def encrypt_using_server(appid, refid, data, token):
    '''
    Encrypt 'data' using server APIs.

    Args:
        data: str (base64 encoded if needed) 
    Returns:
        encrypted data as str 
    '''
    url = ROOT_URL + '/v1/cryptomanager/encrypt'
    j = {
        "id" : "string",
        "metadata" : {},
        "request" : {
            "applicationId" : appid,
            "data": data,
            "referenceId" : refid,
            "timeStamp" :  get_timestamp(),
            "salt" : None
        },
        "requesttime" : get_timestamp(),
        "version" : "1.0"
    }
    cookies = {'Authorization' : token}
    r = requests.post(url, json = j, cookies=cookies)
    r = r.content.decode() # to str 
    r = json.loads(r)
    return r['response']['data'] 

def zip_packet(regid, base_path, out_dir):
    '''
    Args:
        regid: Registration id - this will be the name of the packet
        base_path:  Zip will cd into this dir and archive from here
        out_dir: Dir in which zip file will be written 
    Returns:
        path of zipped packet
    '''
    out_path = os.path.join(out_dir, regid) 
    shutil.make_archive(out_path, 'zip', base_path) 
    return out_path + '.zip'

def decrypt_using_server(appid, refid, data, token):
    '''
    Args:
        data: str
    Returns:
        decrypted data as str 
    '''
    url = ROOT_URL + '/v1/cryptomanager/decrypt'
    j = {
        "id" : "string",
        "metadata" : {},
        "requesttime" : get_timestamp(),
        "version" : "1.0",
        "request" : {
            "applicationId" : appid,
            "data": data,
            "referenceId" : refid,
            "timeStamp" :  get_timestamp(),
            "salt" : None
        }
    }
    cookies = {'Authorization' : token}
    r = requests.post(url, json = j, cookies=cookies)
    print_response(r)
    r = r.content.decode() # to str 
    r = json.loads(r)
    return r['response']['data'] 

def sync_packet(regid, packet_hash, packet_size, refid, token,
                publickey):
    url = DMZ_URL +  '/registrationprocessor/v1/registrationstatus/sync' 
    cookies = {'Authorization' : token}
    # TODO: code repetition below w.r.t. to refid in get_public_key()
    headers = {'Center-Machine-RefId' : refid,
               'timestamp' : get_timestamp(),
               'Content-Type' : 'application/json'} 
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

    s = json.dumps(j)
    bytes_s = s.encode()
    b64_s = base64.urlsafe_b64encode(bytes_s).decode()
    appid = 'REGISTRATION'
    encrypted = encrypt_using_server(appid, refid, b64_s, token)
    print('Encrypted:')
    print(encrypted)
    # encrypted is string
    encrypted = '"' + encrypted + '"' 
    r = requests.post(url, data=encrypted, cookies=cookies, headers=headers) 
    print_response(r)

def encrypt_packet(packet_zip, out_packet_zip, center_id, machine_id, token):
    '''
    Given an uncrypted zip file of a packet encrypt and write as out_packet_zip
    Returns:
        hash and size of the encrypted packet
    '''
    refid = center_id + '_' + machine_id
    data = open(packet_zip, 'rb').read()
    data =  base64.urlsafe_b64encode(data)
    data = data.decode() # to str
    appid = 'REGISTRATION'
    print('Encrypting using server')
    encrypted = encrypt_using_server(appid, refid, data, token) # b64 encoded
    fd = open(out_packet_zip, 'wb')
    fd.write(encrypted.encode())
    fd.close()

    phash = sha256_hash(encrypted.encode())
    psize = len(encrypted.encode())

    return phash, psize 

def upload_packet(packet_file, token):
    url =  DMZ_URL +  '/registrationprocessor/v1/packetreceiver/registrationpackets'
    cookies = {'Authorization' : token}
    files = {packet_file : open(packet_file, 'rb')}
    r = requests.post(url, files=files, cookies=cookies)
    return r

def update_packet_date(packet_path, days_offset=None):
    '''
    Modifies creation date of the packet_meta_info.json to current date
    '''
    fp = open(os.path.join(packet_path, 'packet_meta_info.json'), 'rt')
    j = json.load(fp)
    fp.close()

    meta = j['identity']['metaData']
    for m in meta:
        if m['label'] == 'creationDate':
            m['value'] = get_timestamp(days_offset)
    
    fp = open(os.path.join(packet_path, 'packet_meta_info.json'), 'wt')
    json.dump(j, fp, indent='    ')
    fp.close()


def create_packet_zip(regid, packet_path, ts, out_dir, days_offset=None):
    '''
    The creation date of the packet needs to updated, and then packed zipped.
    Args:
        regid: Registration id - this will be the name of the packet
        packet_path:  Zip will cd into this dir and archive from here
        out_dir: Dir in which zip file will be written 
    Returns:
        path of zipped packet
    '''
    update_packet_date(packet_path, days_offset)
    packet_zip = zip_packet(regid, packet_path, out_dir)
    return packet_zip 
    
def test_reg_proc(center_id, machine_id, packet_path, user, passwd, 
                  serial_number):
    '''
    1. First get authorization token (whos?) 
    2. Using keymanager API get public key of center_machine (rid)
    3. Create packet and encrypt using the above public key
    4. Sync Packet
    5. Upload packet
    '''

    token = auth_get_token('registrationprocessor', user, passwd, ROOT_URL)
    publickey = get_public_key('REGISTRATION', center_id, machine_id, token)

    # Always created regid after publickey, otherwise timestamp of packet
    # will be ahead of public key creation.
    regid, ts = get_regid(center_id, machine_id, serial_number)
    out_dir = './data/packet/unencrypted'
    print('Creating zip')
    packet_zip = create_packet_zip(regid, packet_path, ts, out_dir, days_offset=5)
    print ('Encrypting packet')
    encrypted_packet = os.path.join('./data/packet/encrypted/', 
                                  os.path.basename(packet_zip)) 
    phash, psize = encrypt_packet(packet_zip, encrypted_packet, center_id, 
                                 machine_id, token)

    refid = center_id + '_' + machine_id
    sync_packet(regid, phash, psize, refid, token, publickey)

    r = upload_packet(encrypted_packet, token)

    print_response(r)

    print('\nCheck if the packet is uploaded to HDFS in /user/regprocessor folder')

def get_reg_centers(token):
    url = ROOT_URL + '/v1/masterdata/registrationcenters'
    cookies = {'Authorization' : token}
    r = requests.get(url, cookies=cookies)
    return r

def get_syncdata_configs(token, center_id, mac_address=None):
    #url = 'http://localhost/v1/syncdata/configs'
    #url = 'http://localhost/v1/syncdata/userdetails/%s' % center_id'
    if mac_address is not None:
        url = 'http://localhost/v1/syncdata/masterdata?macaddress=%s' % mac_address
    #url = 'http://localhost/v1/authmanager/usersaltdetails/registrationclient'
    #url = ' http://localhost/v1/keymanager/publickey/KERNEL?timeStamp=2019-10-27T03:38:19.053Z&referenceId=SIGN'

    cookies = {'Authorization' : token}
    r = requests.get(url, cookies=cookies)
    return r

def sign_request():
    token = auth_get_token('registrationclient', 'registration_supervisor', 'mosip')
    url = 'http://localhost/v1/keymanager/sign'
    j = {
        "id": "SIGNATURE.REQUEST",
        "metadata": {},
        "request": {
          "applicationId": "KERNEL",
          "referenceId": "SIGN",
          "data" : "hello",
          "timeStamp": "2019-10-28T05:59:29.928Z"
        },

        "requesttime": "2018-10-28T06:12:52.994Z",

        "version": "v1.0"
    }
    cookies = {'Authorization' : token}
    r = requests.post(url, json=j, cookies=cookies)

    return r



def test_master_services(user, passwd):
    token = auth_get_token('registrationprocessor', user, passwd)
    r = get_reg_centers(token)
    return r


def test_sync_services(center_id, machine_id, user, passwd, mac_address):
    token = auth_get_token('registrationclient', user, passwd)
    r = get_syncdata_configs(token, center_id, mac_address)
    return r

def main():
    #prereg_send_otp()
    center_id = '10001'
    machine_id = '10001'
    mac_address = 'E8-6A-64-1F-27-E6'
  
    #token = auth_get_token('registrationprocessor', 'testuser', 'testuser', ROOT_URL)
    #print(token)

    #r = validate_token(token)
    #print_response(r)
    #publickey = get_public_key('REGISTRATION', center_id, machine_id, token)
    #r = test_master_services('testuser1', 'mosip') 
    #r =  test_sync_services(center_id, machine_id, 'testuser1', 'mosip', 
    #                        mac_address)
    #r = sign_request()
    #print_response(r)
    test_reg_proc(center_id, machine_id, './data/packet/unencrypted/packet1',
                  'testuser', 'testuser', serial_number = 1) # Serial number is arbitrary

if __name__=='__main__':
    main() 

