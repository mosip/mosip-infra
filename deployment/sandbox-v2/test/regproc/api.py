import datetime as dt
import requests
import json
import base64
import os
import secrets
import sys
sys.path.insert(0, '../')
from utils import *

class MosipSession:
    def __init__(self, server, user, password, appid='regproc', ssl_verify=True):
        self.server = server
        self.user = user
        self.password = password
        self.ssl_verify = ssl_verify
        self.token = self.auth_get_token(appid, self.user, self.password) 
      
    def auth_get_token(self, appid, username, password):
        url = '%s/v1/authmanager/authenticate/useridPwd' % self.server
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
        r = requests.post(url, json = j, verify=self.ssl_verify)
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
        url = '%s/v1/keymanager/encrypt' % self.server
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
        r = requests.post(url, json = j, cookies=cookies, verify=self.ssl_verify)
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
        url = '%s/registrationprocessor/v1/registrationstatus/sync' % self.server
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
        r = requests.post(url, data=encrypted, cookies=cookies, headers=headers, verify=self.ssl_verify)
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

    def decrypt_using_server(self, appid, refid, data):
        '''
        Decrypt 'data' using server APIs.
    
        Args:
            data: str (base64 encoded)
        Returns:
            decrypt data as str 
        '''
        url = '%s/v1/keymanager/decrypt' % self.server
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
        cookies = {'Authorization' : self.token}
        r = requests.post(url, json = j, cookies=cookies, verify=self.ssl_verify)
        r = r.content.decode() # to str 
        r = json.loads(r)
        return r['response']['data'] 

    def upload_packet(self, packet_file):
        url = '%s/registrationprocessor/v1/packetreceiver/registrationpackets' % self.server
        cookies = {'Authorization' : self.token}
        files = {packet_file : open(packet_file, 'rb')}
        r = requests.post(url, files=files, cookies=cookies, verify=self.ssl_verify)
        return r

    def get_rid(self, center_id, machine_id):
        url = '%s/v1/ridgenerator/generate/rid/%s/%s' % (self.server, center_id, machine_id)
        cookies = {'Authorization' : self.token}
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        r = r.content.decode() # to str 
        r = json.loads(r)
        rid = r['response']['rid'] 
        return rid


    def generate_master_key(self, appid, cname, refid=''): 
        url = '%s/v1/keymanager/generateMasterKey/CERTIFICATE' % (self.server)
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
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        return r

    def update_masterdata_devicetype(self, device_code, device_name, device_description):
        url = '%s/v1/masterdata/devicetypes' % (self.server)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            "id": "string",
            "metadata": {},
            "request": {
                "code": device_code,
                "description": device_description,
                "isActive": 'true',
                "langCode": "eng",
                "name": device_name 
             },
            "requesttime": ts,
            "version": "1.0"
        }
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        if r['errors']:
          if r['errors'][0]['errorCode'] == 'KER-MSD-994':  # Resend with PUT
              r = requests.put(url, cookies=cookies, json = j, verify=self.ssl_verify)
              r = response_to_json(r)
        return r # Sucess

    def update_masterdata_device_spec(self, brand, description, type_code, name, spec_id, driver_version, model): 
        url = '%s/v1/masterdata/devicespecifications' % (self.server)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          'id': 'string',
          'metadata': {},
          'request': {
            'id': spec_id,
            'brand': brand,
            'description': description,
            'deviceTypeCode': type_code,
            'isActive': True,
            'langCode': 'eng',
            'minDriverversion': driver_version, 
            'model': model, 
            'name': name
          },
          'requesttime': ts,
          'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r 

    def add_masterdata_device(self, device_spec, device_id ):
        url = '%s/v1/masterdata/devices' % (self.server)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            "id": "string",
            "metadata": {},
            "request": {
              "deviceSpecId": "string",
              "id": "string",
              "ipAddress": "string",
              "isActive": true,
              "langCode": "string",
              "macAddress": "string",
              "name": "string",
              "regCenterId": "string",
              "serialNum": "string",
              "validityDateTime": "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
              "zoneCode": "string"
            },
            "requesttime": "2018-12-10T06:12:52.994Z",
            "version": "string"
        }
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r 

