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
    def __init__(self, server, user, pwd, appid='admin', ssl_verify=True):
        self.server = server
        self.user = user
        self.pwd = pwd
        self.ssl_verify = ssl_verify 
        self.token = self.auth_get_token(appid, self.user, self.pwd) 
      
    def auth_get_token(self, appid, username, pwd):
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
                    "password": pwd
            }
        }
        r = requests.post(url, json = j, verify=self.ssl_verify)
        token = read_token(r)
        return token

    def add_machine_type(self, code, name, description, language, update=False):
        url = '%s/v1/masterdata/machinetypes' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
              'code': code,
              'name': name, 
              'description': description, 
              'isActive': True,
              'langCode': language,
            },
            'requesttime': ts,
            'version': '1.0'
        } 
        if update:
            r = requests.put(url, cookies=cookies, json = j, verify=self.ssl_verify)
        else:
            r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def add_machine_spec(self, name, type_code,  brand, model, description, language, min_driver_ver,
                         update=False):
        url = '%s/v1/masterdata/machinespecifications' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'id': '',
                'name': name,
                'machineTypeCode': type_code,
                'brand': brand,
                'model': model,
                'description': description,
                'isActive': True,
                'langCode': language,
                'minDriverversion': min_driver_ver,
            },
            'requesttime': ts,
            'version': '1.0'
          }
        r = self.get_specs()
        try:
            for item in r['response']['data']:
              if item['name'] == name:
                  j['request']['id'] = item['id']
        except:
            pass

        if update:
            r = requests.put(url, cookies=cookies, json = j, verify=self.ssl_verify)
        else:
            r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)

        r = response_to_json(r)
        return r

    def get_specs(self):
        url = '%s/v1/masterdata/machinespecifications/all' % self.server
        cookies = {'Authorization' : self.token}
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def get_spec_id(self, name):
        spec_id = None
        r = self.get_specs()
        try:
            for item in r['response']['data']:
              if item['name'] == name:
                  spec_id = item['id']
        except:
          pass
        return spec_id

    def get_machines(self):
        url = '%s/v1/masterdata/machines' % self.server
        cookies = {'Authorization' : self.token}
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)
        return r
 
    def get_machine_id(self, name):
        machine_id = ''
        out = self.get_machines()
        print(out)
        exit(0)

    def add_machine(self, machine_id, name, spec_name, regcenter, zone, pub_key, sign_pub_key, valid_days, 
                    language, update=False):
        spec_id = self.get_spec_id(spec_name)
        url = '%s/v1/masterdata/machines' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        validity =  get_timestamp(seconds_offset=valid_days * 86400)
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
              'id': machine_id,
              'name': name,
              'ipAddress': '', # Unused
              'isActive': True,
              'langCode': language,
              'macAddress': '',  # Unused
              'machineSpecId': spec_id,
              'publicKey': pub_key,
              'regCenterId': regcenter,
              'serialNum': '', # Unused
              'signPublicKey': sign_pub_key,
              'validityDateTime': validity, # 'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'',
              'zoneCode': zone
            },
            'requesttime': ts,
            'version': '1.0'
          }

        if update:
            r = requests.put(url, cookies=cookies, json = j, verify=self.ssl_verify)
        else:
            r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r



