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
    def __init__(self, server, user, pwd, appid='admin'):
        self.server = server
        self.user = user
        self.pwd = pwd
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
        r = requests.post(url, json = j)
        token = read_token(r)
        return token

    def add_type(self, code, name, description, language):
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
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def update_machine_type(self, code, name, description, language):
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
        r = requests.put(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def add_spec(self, machine_id, name, type_code,  brand, model, description, language, min_driver_ver):
        url = '%s/v1/masterdata/machinespecifications' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'id': machine_id, 
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
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def update_machine_spec(self, machine_id, name, type_code,  brand, model, description, language, 
                            min_driver_ver):
        url = '%s/v1/masterdata/machinespecifications' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'id': machine_id, 
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
        r = requests.put(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def get_specs(self):
        url = '%s/v1/masterdata/machinespecifications/all' % self.server
        cookies = {'Authorization' : self.token}
        r = requests.get(url, cookies=cookies)
        r = response_to_json(r)
        return r

    def get_machines(self):
        url = '%s/v1/masterdata/machines' % self.server
        cookies = {'Authorization' : self.token}
        r = requests.get(url, cookies=cookies)
        r = response_to_json(r)
        return r

    def add_machine(self, machine_id, name, spec_id, public_key, reg_center_id, serial_num, sign_pub_key, 
                    validity, zone, language):
        url = '%s/v1/masterdata/machines' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
              'id': machine_id,
              'name': name,
              'ipAddress': '', # Unused
              'isActive': True,
              'macAddress': '',  # Unused
              'machineSpecId': spec_id,
              'publicKey': public_key,
              'regCenterId': reg_center_id,
              'serialNum': serial_num,
              'signPublicKey': sign_pub_key,
              'validityDateTime': validity, # 'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'',
              'zoneCode': zone,
              'langCode': language,
            },
            'requesttime': ts,
            'version': '1.0'
          }
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def update_machine(self, machine_id, name, spec_id, public_key, reg_center_id, serial_num, sign_pub_key, 
                    validity, zone, language):
        url = '%s/v1/masterdata/machines' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
              'id': machine_id,
              'name': name,
              'ipAddress': '', # Unused
              'isActive': True,
              'macAddress': '',  # Unused
              'machineSpecId': spec_id,
              'publicKey': public_key,
              'regCenterId': reg_center_id,
              'serialNum': serial_num,
              'signPublicKey': sign_pub_key,
              'validityDateTime': validity, # 'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'',
              'zoneCode': zone,
              'langCode': language,
            },
            'requesttime': ts,
            'version': '1.0'
          }
        r = requests.put(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r


