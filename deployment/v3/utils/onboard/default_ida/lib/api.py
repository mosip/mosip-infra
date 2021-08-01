import requests
import sys
sys.path.insert(0, '../')
from utils import *

class MosipSession:
    def __init__(self, server, user, pwd, appid='ida', ssl_verify=True):
        self.server = server
        self.user = user
        self.pwd = pwd
        self.ssl_verify = ssl_verify
        self.token = self.auth_get_token(appid, self.user, self.pwd) 
      
    def auth_get_token(self, appid, client_id, pwd):
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

    def get_ida_internal_cert(self, app_id, ref_id=None):
        if ref_id is None:
            url = '%s/idauthentication/v1/internal/getCertificate?applicationId=%s' %  (self.server, app_id)
        else:
            url = '%s/idauthentication/v1/internal/getCertificate?applicationId=%s&referenceId=%s' % \
                   (self.server, app_id, ref_id)
        cookies = {'Authorization' : self.token}
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
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

    def upload_ca_certificate(self, cert_data, partner_domain):
        '''
        cert_data: str
        '''
        url = '%s/v1/partnermanager/partners/certificate/ca/upload' % self.server
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

    #def upload_partner_certificate(self, cert_data, org_name, partner_domain, partner_id, partner_type):
    def upload_partner_certificate(self, cert_data, partner_domain, partner_id):
        '''
        cert_data: str
        '''
        url = '%s/v1/partnermanager/partners/certificate/upload' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'certificateData': cert_data,
                #'organizationName': org_name,
                'partnerDomain': partner_domain,
                'partnerId': partner_id,
                #'partnerType': partner_type
            },
            'requesttime': ts,
            'version': '1.0'
        }

        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)

        return r

    def get_partner_cert(self, partner_id):
        url = '%s/v1/partnermanager/partners/%s/certificate' % (self.server, partner_id)
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)

        return r


    def upload_other_domain_cert_to_keymanager(self, app_id, ref_id, cert_data):
        '''
        cert_data: str
        '''
        url = '%s/v1/keymanager/uploadOtherDomainCertificate' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
          'id': 'string',
          'metadata': {},
          'request': {
            'applicationId': app_id,
            'certificateData': cert_data,
            'referenceId': ref_id
          },
          'requesttime': ts,
          'version': '1.0'
        }

        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r
