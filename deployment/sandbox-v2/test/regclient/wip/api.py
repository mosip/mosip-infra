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
    def __init__(self, server, user, password, appid='admin'):
        self.server = server
        self.user = user
        self.password = password
        self.token = self.auth_get_token(appid, self.user, self.password) 
      
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

    def update_masterdata_devicetype(self, device_code, device_name, device_description, lang):
        url = 'https://%s/v1/masterdata/devicetypes' % (self.server)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            "id": "string",
            "metadata": {},
            "request": {
                "code": device_code,
                "description": device_description,
                "isActive": True,
                "langCode": lang,
                "name": device_name 
             },
            "requesttime": ts,
            "version": "1.0"
        }
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        if r['errors']:
          err_code = r['errors'][0]['errorCode'] 
          if err_code == 'KER-MSD-994' or err_code == 'KER-MSD-053':  # Resend with PUT
              r = requests.put(url, cookies=cookies, json = j)
              r = response_to_json(r)
        return r # Sucess

    def update_masterdata_device_spec(self, brand, description, type_code, name, spec_id, driver_version, model, lang): 
        url = 'https://%s/v1/masterdata/devicespecifications' % (self.server)
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
            'langCode': lang,
            'minDriverversion': driver_version, 
            'model': model, 
            'name': name
          },
          'requesttime': ts,
          'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r 

    def add_masterdata_device(self, device_id, name, spec, reg_center, valid_upto, zone): 
        url = 'https://%s/v1/masterdata/devices' % (self.server)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
              'deviceSpecId': spec, 
              'id': device_id,
              'ipAddress': '192.168.0.1', # TODO: Not used?
              'isActive': True,
              'langCode': 'eng',
              'macAddress': 'XX-YY-ZZ-AA-BB', # TODO: Not used?
              'name': name,
              'regCenterId': reg_center,
              'serialNum': '0',
              'validityDateTime': valid_upto,
              'zoneCode': zone 
            },
            'requesttime': '2018-12-10T06:12:52.994Z',
            'version': 'string'
        }
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r 

