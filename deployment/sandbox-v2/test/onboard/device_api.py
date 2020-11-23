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

    def add_policy_group(self, name, description):
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

    def get_policy_groups(self):
        cookies = {'Authorization' : self.token}
        url = 'https://%s/partnermanagement/v1/policies/policies/policyGroups' % self.server
        r = requests.get(url, cookies=cookies)
        return r

    def add_policy(self, name, description, policy, policy_group, policy_type):
        '''
        policies: dict with policies structure
        '''
        url = 'https://%s/partnermanagement/v1/policies/policies' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                 'name': name,
                 'desc' : description,
                 'policies': policy,
                 'policyGroupName': policy_group,
                 'policyType': policy_type
             },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j)
        return r

    def update_policy(self, name, description, policy, policy_group, policy_type, policy_id):
        '''
        policies: dict with policies structure
        policy_id: str
        '''
        url = 'https://%s/partnermanagement/v1/policies/policies/%s' % (self.server, policy_id)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                 'name': name,
                 'desc' : description,
                 'policies': policy,
                 'policyGroupName': policy_group,
                 'policyType': policy_type
             },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.put(url, cookies=cookies, json = j)
        return r

    def get_policies(self):
        cookies = {'Authorization' : self.token}
        url = 'https://%s/partnermanagement/v1/policies/policies' % self.server
        r = requests.get(url, cookies=cookies)
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

    def publish_policy(self, policy_group_id, policy_id):
        url = 'https://%s/partnermanagement/v1/policies/policies/publishPolicy/policyGroupId/%s/policyId/%s' % (
              self.server, policy_group_id, policy_id)
        cookies = {'Authorization' : self.token}
        r = requests.post(url, cookies=cookies)
        return r

    def upload_ca_certificate(self, cert_data, partner_domain):
        '''
        cert_data: str
        '''
        url = 'https://%s/partnermanagement/v1/partners/partners/uploadCACertificate' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          'id': 'string',
          'metadata': {},
          'request': {
            'certificateData': cert_data,
            'partnerDomain': partner_domain
          },
          'requesttime': ts,
          'version': '1.0'
        } 

        r = requests.post(url, cookies=cookies, json = j)

        return r

    def upload_partner_certificate(self, cert_data, org_name, partner_domain, partner_id, partner_type):
        '''
        cert_data: str
        '''
        url = 'https://%s/partnermanagement/v1/partners/partners/uploadPartnerCertificate' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'certificateData': cert_data,
                'organizationName': org_name,
                'partnerDomain': partner_domain,
                'partnerId': partner_id,
                'partnerType': partner_type
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

    def add_device_spec_in_masterdb(self, device_id, name, description, device_type, brand, model, min_driver_ver,
                                    language):
        url = 'https://%s/v1/masterdata/devicespecifications' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          'id': 'string',
          'metadata': {},
          'request': {
            'id': device_id,
            'name': name,
            'description': description,
            'deviceTypeCode': device_type,
            'brand': brand,
            'model': model,
            'isActive': "true",
            'langCode': language,
            'minDriverversion': min_driver_ver
          },
          'requesttime': ts,
          'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j)
        return r

    def add_device_type_in_masterdb(self, code, name, description, language, update=False):
        '''
        By default, devices are added. If update is true, then put request is sent
        '''
        url = 'https://%s/v1/masterdata/devicetypes' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          'id': 'string',
          'metadata': {},
          'request': {
            'code': code,
            'description': description,
            'isActive': "true",
            'langCode': language,
            'name': name
          },
          'requesttime': ts,
          'version': '1.0'
        }
        if update:
            r = requests.put(url, cookies=cookies, json = j)
        else:
            r = requests.post(url, cookies=cookies, json = j)

        return r

    def add_device_in_masterdb(self, device_id, spec_id, name, serial_num, reg_center, valid_till, language, zone,
                               update=False):
        '''
        By default, devices are added. If update is true, then put request is sent
        '''
        url = 'https://%s/v1/masterdata/devices' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          'id': 'string',
          'metadata': {},
          'request': {
            'id': device_id,
            'name': name,
            'deviceSpecId': spec_id,
            'ipAddress': '', # Unused
            'isActive': True, 
            'langCode': language,
            'macAddress': '',  # Unused 
            'regCenterId': reg_center,
            'serialNum': serial_num,
            'validityDateTime': valid_till, # format'2021-10-01T11:24:47.241Z'
            'zoneCode': zone
          },
          'requesttime': ts,
          'version': '1.0'
        }

        if update:
            r = requests.put(url, cookies=cookies, json = j)
        else:
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

    def add_pms_key_alias(self):
        '''
        TODO: Key alias must be populated while launching the kernel as one of init jobs. Since that's
        missing at the moment, we are using this api.  
        '''
        url = 'https://%s/v1/keymanager/generateMasterKey/CSR' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          'id': 'string',
          'metadata': {},
          'request': {
            'applicationId': 'PMS',
            'commonName': 'MOSIP-PMS',
            'country': 'IN',
            'force': False,
            'location': 'BANGALORE',
            'organization': 'IIITB',
            'organizationUnit': 'MOSIP-TECH-CENTER',
            'referenceId': '',
            'state': 'KA'
          },
          'requesttime': ts,
          'version': '1.0'
        }

        r = requests.post(url, cookies=cookies, json = j)
        return r
        
