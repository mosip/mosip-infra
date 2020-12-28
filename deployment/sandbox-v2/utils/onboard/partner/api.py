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
    def __init__(self, server, user, pwd, appid='admin', ssl_verify=True, client_token=False):
        self.server = server
        self.user = user
        self.pwd = pwd
        self.ssl_verify = ssl_verify
        if client_token:
            self.token = self.auth_get_client_token(appid, self.user, self.pwd) 
        else:
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

    def auth_get_client_token(self, appid, client_id, pwd):
        url = '%s/v1/authmanager/authenticate/clientidsecretkey' % self.server
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'appId': appid,
                'clientId': client_id,
                'secretKey': pwd
            },
            'requesttime': ts,
            'version': '1.0'
        }

        r = requests.post(url, json = j, verify=self.ssl_verify)
        token = read_token(r)
        return token

    def add_policy_group(self, name, description):
        url = '%s/partnermanagement/v1/policies/policies/policyGroup' % self.server
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
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def get_policy_groups(self):
        cookies = {'Authorization' : self.token}
        url = '%s/partnermanagement/v1/policies/policies/policyGroups' % self.server
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def add_policy(self, policy_id, name, description, policy, policy_group, policy_type):
        '''
        policies: dict with policies structure
        '''
        url = '%s/partnermanagement/v1/policies/policies' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                 'policyId' : policy_id,
                 'name': name,
                 'desc' : description,
                 'policies': policy,
                 'policyGroupName': policy_group,
                 'policyType': policy_type,
                 'version': 1
             },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def update_policy(self, name, description, policy, policy_group, policy_type, policy_id):
        '''
        policies: dict with policies structure
        policy_id: str
        '''
        url = '%s/partnermanagement/v1/policies/policies/%s' % (self.server, policy_id)
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
                 'policyType': policy_type,
                 'version': 1
             },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.put(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def get_policies(self):
        cookies = {'Authorization' : self.token}
        url = '%s/partnermanagement/v1/policies/policies' % self.server
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)
        return r
        
    def add_partner(self, name, contact, address, email, partner_id, partner_type, policy_group):
        url = '%s/partnermanagement/v1/partners/partners' % self.server
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
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def publish_policy(self, policy_group_id, policy_id):
        url = '%s/partnermanagement/v1/policies/policies/publishPolicy/policyGroupId/%s/policyId/%s' % (
              self.server, policy_group_id, policy_id)
        cookies = {'Authorization' : self.token}
        r = requests.post(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def get_partner_api_key_requests(self, partner_id):
        url = '%s/partnermanagement/v1/partners/partners/%s/partnerAPIKeyRequests' % (self.server, partner_id)
        cookies = {'Authorization' : self.token}
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def add_partner_api_key_requests(self, partner_id, policy_name, description):
        url = '%s/partnermanagement/v1/partners/partners/%s/partnerAPIKeyRequests' % (self.server, 
                                                                                              partner_id)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'policyName': policy_name,
                'useCaseDescription': description
            },
            'requesttime': ts,
            'version': '1.0'
        } 

        r = requests.patch(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def approve_partner_policy(self, api_request_id, status):
        '''
        status: Approved/
        '''
        url = '%s/partnermanagement/v1/pmpartners/pmpartners/PartnerAPIKeyRequests/%s' % (self.server,
                                                                                                 api_request_id) 
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
              'status': status 
            },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.patch(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def upload_ca_certificate(self, cert_data, partner_domain):
        '''
        cert_data: str
        '''
        url = '%s/partnermanagement/v1/partners/partners/uploadCACertificate' % self.server
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

        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)

        return r

    def upload_partner_certificate(self, cert_data, org_name, partner_domain, partner_id, partner_type):
        '''
        cert_data: str
        '''
        url = '%s/partnermanagement/v1/partners/partners/uploadPartnerCertificate' % self.server
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

        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)

        return r

    def upload_other_domain_cert(self, cert, app_id, ref_id):
        url = '%s/v1/keymanager/uploadOtherDomainCertificate' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp() 
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'certificateData': cert,
                'applicationId': app_id, 
                'referenceId': ref_id
            },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r 

    def add_pms_key_alias(self):
        '''
        TODO: Key alias must be populated while launching the kernel as one of init jobs. Since that's
        missing at the moment, we are using this api.  
        '''
        url = '%s/v1/keymanager/generateMasterKey/CSR' % self.server
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

        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r
        
    def create_misp(self, org_name, address, contact, email):
        url = '%s/partnermanagement/v1/misps/misps' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
              'organizationName': org_name,
              'address': address,
              'contactNumber': contact, 
              'emailId': email
            },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def get_misps(self):
        url = '%s/partnermanagement/v1/misps/misps' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def approve_misp(self, misp_id, status):
        url = '%s/partnermanagement/v1/misps/misps/%s/status' % (self.server, misp_id)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
              'mispId': misp_id,
              'mispStatus': status
            },
            'requesttime': ts,
            'version': '1.0'
          }
        r = requests.patch(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r
   
    def add_extractor(self, partner_id, policy_id, attribute, biometric, provider, version):
        url = '%s/partnermanagement/v1/partners/partners/partnerId/%s/policyId/%s' % (self.server, partner_id, 
                                                                                      policy_id)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'extractors': [{
                     'attributeName': attribute,
                     'biometric': biometric,
                      'extractor': {
                          'provider': provider,
                          'version': version
                      }
                }]
            },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def get_ida_internal_cert(self, app_id, ref_id):
        url = '%s/idauthentication/v1/internal/getCertificate?applicationId=%s&referenceId=%s' % \
               (self.server, app_id, ref_id)
        cookies = {'Authorization' : self.token}
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)
        return r
