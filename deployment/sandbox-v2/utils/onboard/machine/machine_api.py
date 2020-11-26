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
                    "password": pwd
            }
        }
        r = requests.post(url, json = j)
        token = read_token(r)
        return token

    def add_machine_type(self, code, name, description, language):
        url = 'https://%s/v1/masterdata/machinetypes' % self.server
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
        return r

    def update_machine_type(self, code, name, description, language):
        url = 'https://%s/v1/masterdata/machinetypes' % self.server
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
        return r

    def add_machine_spec(self, machine_id, name, type_code,  brand, model, description, language, min_driver_ver):
        url = 'https://%s/v1/masterdata/machinespecifications' % self.server
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
        return r
