import datetime as dt
import requests
import json
import hashlib
import base64
import os
import shutil
import secrets
import re

class MosipSession:
    def __init__(self, server, user, password):
        self.server = server
        self.user = user
        self.password = password
        self.appid = 'ROOT'  # For internal calls  
        self.token = self.auth_get_token('regproc', self.user, self.password) 
      
    def auth_get_token(self, appid, username, password):
        url = 'https://%s/v1/authmanager/authenticate/useridPwd' % self.server
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

    def encrypt_using_server(self, appid, refid, data, b64_encode=False):
        '''
        Encrypt 'data' using server APIs.
    
        Args:
            data: str (base64 encoded if needed) 
            b64_encode: Whether to base64 encode the final output
        Returns:
            encrypted data as str 
        '''
        nonce_len = 12
        aad_len = 32 
     
        nonce = secrets.token_bytes(nonce_len)
        aad  =  secrets.token_bytes(aad_len)
        url = 'https://%s/v1/keymanager/encrypt' % self.server
        j = {
            "id" : "string",
            "metadata" : {},
            "request" : {
                "applicationId" : appid,
                "data": data,
                "referenceId" : refid,
                "timeStamp" :  get_timestamp(),
                "salt" : base64.urlsafe_b64encode(nonce).decode(), # bytes->str
                "aad" : base64.urlsafe_b64encode(aad).decode()
            },
            "requesttime" : get_timestamp(),
            "version" : "1.0"
        }
        cookies = {'Authorization' : self.token}
        r = requests.post(url, json = j, cookies=cookies)
        r = r.content.decode() # to str 
        r = json.loads(r)
        enc = r['response']['data']  # str
        enc += "=" * ((4 - len(enc) % 4) % 4)  # Provide padding
        enc = base64.urlsafe_b64decode(enc) # bytes
        enc = nonce + aad + enc  # bytes.  prepend nonce and aad
        if b64_encode:
           enc = base64.urlsafe_b64encode(enc)  #  b64 bytes
           enc = enc.decode()  # b64 str
        return enc  

    def sync_packet(self, regid, packet_hash, packet_size, refid):
        url = 'https://%s/registrationprocessor/v1/registrationstatus/sync' % self.server
        cookies = {'Authorization' : self.token}
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
        encrypted = self.encrypt_using_server(appid, refid, b64_s, b64_encode=True)
        # encrypted is string
        encrypted = '"' + encrypted + '"'
        r = requests.post(url, data=encrypted, cookies=cookies, headers=headers)
        return r 

    # in_path: full path of the unencrypted file
    # out_dir: output dir where the encrypted file will be written
    def encrypt_packet(self, in_path, out_dir, packet_name, refid):
        packet = open(in_path, 'rb').read()
        b64_s = base64.urlsafe_b64encode(packet).decode()  # convert to str
        encrypted_packet = self.encrypt_using_server('REGISTRATION', refid, b64_s)
        # First write the encrypted packet
        encrypted_path =  os.path.join(out_dir, packet_name)
        fd = open(encrypted_path, 'wb')
        #fd.write(encrypted_packet.encode())  # convert encrypted_packet to type 'bytes' and write
        fd.write(encrypted_packet)
        fd.close()
        return encrypted_path

    def upload_packet(self, packet_file):
        url = 'https://%s/registrationprocessor/v1/packetreceiver/registrationpackets' % self.server
        cookies = {'Authorization' : self.token}
        files = {packet_file : open(packet_file, 'rb')}
        r = requests.post(url, files=files, cookies=cookies)
        return r

    def get_rid(self, center_id, machine_id):
        url = 'https://%s/v1/ridgenerator/generate/rid/%s/%s' % (self.server, center_id, machine_id)
        cookies = {'Authorization' : self.token}
        r = requests.get(url, cookies=cookies)
        r = r.content.decode() # to str 
        r = json.loads(r)
        rid = r['response']['rid'] 
        return rid


    def generate_master_key(self, appid, cname, refid=''): 
        url = 'https://%s/v1/keymanager/generateMasterKey/CERTIFICATE' % (self.server)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j =  {
            "id": "mosip.master",
            "metadata": {},
            "request": {
              "applicationId": appid, 
              "commonName": cname,
              "country": "IN",
              "force": False,
              "location": "BANGALORE",
              "organization": "IIITB",
              "organizationUnit": "MOSIP-TECH-CENTER",
              "referenceId": refid,
              "state": "KA",
            },
            "requesttime": ts,
            "version": "1.0"
        }
        r = requests.post(url, cookies=cookies, json = j)
        return r

def read_token(response):
    cookies = response.headers['Set-Cookie'].split(';')
    for cookie in cookies:
        key = cookie.split('=')[0]
        value = cookie.split('=')[1]
        if key == 'Authorization':
            return value

    return None

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


def decrypt_using_server(appid, refid, data, token, server):
    '''
    Decrypt 'data' using server APIs.

    Args:
        data: str (base64 encoded)
    Returns:
        decrypt data as str 
    '''
    url = 'https://%s/v1/keymanager/decrypt' % server
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
    


def sha256_hash(data):
    '''
    data assumed as type bytes
    '''
    m = hashlib.sha256()
    m.update(data)
    h = m.hexdigest().upper()
    return h


def print_response(r):
    print(r.headers)
    print(r.links)
    print(r.encoding)
    print(r.status_code)
    print('Size = %s' % len(r.content))
    print('Response Data = %s' % r.content)


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

