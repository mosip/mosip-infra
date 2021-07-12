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

    ## Add machine type
    def add_type(self, code, name, description, language, update=False):
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

    # Add machine spec
    def add_spec(self, name, type_code,  brand, model, description, min_driver_ver, language, update=False):
        url = '%s/v1/masterdata/machinespecifications' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        spec_id = self.get_spec_id(name) 
        print(name, spec_id)
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'id': spec_id,
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
        spec_id = 'dummy'
        r = self.get_specs()
        try:
            for item in r['response']['data']:
              if item['name'] == name:
                  spec_id = item['id']
        except:
          pass
        return spec_id

    def get_machines(self, lang):
        url = '%s/v1/masterdata/machines/search' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j =  {
          'id': 'string',
          'metadata': {},
          'request': {
            'filters':[],
            'sort':[{
              'sortType':'desc',
              'sortField':'createdDateTime'
             }],
            'pagination':{
              'pageStart':0, 
              'pageFetch':10
            },
            'languageCode': lang
          },
         'requesttime': ts,
         'version':'1.0'
        }
        r = requests.post(url, cookies=cookies, json=j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def get_machine_id(self, name, lang): 
        r = self.get_machines(lang)
        if r['response']['data'] is None:
           return None
        for machine in r['response']['data']:
           if machine['name'] == name and machine['langCode'] == lang:
               return machine['id']
        
    def add_machine(self, name, spec_name, regcenter, zone, pub_key, sign_pub_key, valid_days, 
                    lang, primary_lang):
        spec_id = self.get_spec_id(spec_name)
        # Check if machine entry exists for primary lanague
        machine_id = self.get_machine_id(name, primary_lang)
        if machine_id is None:
            machine_id = ''   

        # Check if machine info already exists
        update = True
        r = self.get_machine_id(name, lang)
        if r is None:
            update = False 
        
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
              'langCode': lang,
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



