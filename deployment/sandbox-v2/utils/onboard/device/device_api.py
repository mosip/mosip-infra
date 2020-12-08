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

    def add_device_detail(self, device_detail_id, device_type, device_subtype, for_registration, make, model, 
                          partner_org_name, partner_id):
        url = '%s/partnermanagement/v1/partners/devicedetail' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j ={
          "id": "string",
          "metadata": {},
          "request": {
            "id": device_detail_id,
            "deviceProviderId": partner_id,
            "deviceTypeCode": device_type,
            "deviceSubTypeCode": device_subtype, 
            "isItForRegistrationDevice": for_registration,
            "make": make,
            "model": model, 
            "partnerOrganizationName": partner_org_name
          },
          "requesttime": ts,
          "version": "1.0"
        }
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def approve_device_detail(self, device_detail_id, status, for_registration): # status: Activate/De-activate 
        url = '%s/partnermanagement/v1/partners/devicedetail' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          "id": "string",
          "metadata": {},
          "request": {
            "approvalStatus": status,
            "id": device_detail_id,
            "isItForRegistrationDevice": for_registration
          },
          "requesttime": ts,
          "version": "1.0"
        }
        r = requests.patch(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def add_sbi(self, device_detail_id, sw_hash, sw_create_date, sw_expiry_date, sw_version, 
                for_registration):
        url = '%s/partnermanagement/v1/partners/securebiometricinterface' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          "id": "string",
          "metadata": {},
          "request": {
            "deviceDetailId": device_detail_id,
            "isItForRegistrationDevice": for_registration,
            "swBinaryHash": sw_hash,
            "swCreateDateTime": sw_create_date,
            "swExpiryDateTime": sw_expiry_date,
            "swVersion": sw_version
          },
          "requesttime": ts,
          "version": "string"
        }
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def approve_sbi(self, sbi_id, status, for_registration): 
        '''
        status: Activate/De-activate
        '''
        url = '%s/partnermanagement/v1/partners/securebiometricinterface' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          "id": "string",
          "metadata": {},
          "request": {
            "id": sbi_id,
            "approvalStatus": status,
            "isItForRegistrationDevice": for_registration
          },
          "requesttime": ts,
          "version": "string"
        }
        r = requests.patch(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def register_device(self, device_data):
        '''
        device_data: base64 encoded device data
        '''
        url = '%s/partnermanagement/v1/partners/registereddevices' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
              'deviceData': device_data
            },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

    def add_device_to_masterdb(self, name, serial_num, spec_id, reg_center, zone, validity, language):
        url = '%s/v1/masterdata/devices' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j =  {
            'id': 'string',
            'metadata': {},
            'request': {
              'name': name,
              'deviceSpecId': spec_id,
              'id': '', # Auto generated
              'ipAddress': '192.168.100.1', # Unused
              'isActive': True,
              'langCode': language,
              'macAddress': 'XYZ', # Unused
              'regCenterId': reg_center,
              'serialNum': serial_num, 
              'validityDateTime': validity, # format:  'yyyy-MM-dd'T'HH:mm:ss.SSS'Z'',
              'zoneCode': zone
            },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r

