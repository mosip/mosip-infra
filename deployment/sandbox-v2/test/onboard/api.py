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

    def create_policy_group(self, name, description):
        url = 'https://%s/partnermanagement/v1/policies/policies/policyGroup' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            "id": "string",
            "metadata": {},
            "request": {
                 "name": name,
                 "desc" : description
             },
            "requesttime": ts,
            "version": "1.0"
        }
        r = requests.post(url, cookies=cookies, json = j)
        return r

    def add_partner(self, name, contact, address, email, partner_id, partner_type, policy_group):
        url = 'https://%s/partnermanagement/v1/partners/partners' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          'id': 'string',
          'metadata': {},
          'request': {
            'address': address,
            'contactNumber': contact,
            'emailId': email,
            'organizationName': name,
            'partnerId': partner_id,
            'partnerType': partner_type,
            'policyGroup': policy_group 
          },
          'requesttime': ts,
          'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j)
        return r

    def add_device_detail(self, device_id, device_type, device_subtype, for_registration, make, model, 
                          partner_org_name, partner_id):
        url = 'https://%s/partnermanagement/v1/partners/devicedetail' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j ={
          "id": "string",
          "metadata": {},
          "request": {
            "id": device_id,
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
        return r

    def approve_device_detail(self, device_id, status, for_registration): # status: Activate/De-activate 
        url = 'https://%s/partnermanagement/v1/partners/devicedetail' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          "id": "string",
          "metadata": {},
          "request": {
            "approvalStatus": status,
            "id": device_id,
            "isItForRegistrationDevice": for_registration
          },
          "requesttime": ts,
          "version": "1.0"
        }
        r = requests.patch(url, cookies=cookies, json = j)
        return r

    def add_sbi(self, device_detail_id, sw_hash, sw_create_date, sw_expiry_date, sw_version, 
                for_registration):
        url = 'https://%s/partnermanagement/v1/partners/securebiometricinterface' % self.server
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
        return r

    def approve_sbi(self, sbi_id, status, for_registration): 
        '''
        status: Activate/De-activate
        '''
        url = 'https://%s/partnermanagement/v1/partners/securebiometricinterface' % self.server
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
        return r

