import hmac
from misp_lic_event_data_provider import MISPLicEventDataProvider
from oidc_client_data_provider import OIDCClientDataProvider
from partner_event_data_provider import PartnerEventDataProvider
import hashlib
import requests



#url = 'http://localhost:8093/idauthentication/v1/internal/callback/partnermanagement/misp_license_generated'
#url = 'http://localhost:8093/idauthentication/v1/internal/callback/partnermanagement/partner_updated'
secret = 'Kslk30SNF2AChs2'


def _build_header(event_data:str) -> str:
        secret_bytes = bytes(secret, 'utf-8')
        event_data_bytes = bytes(event_data.replace('\'', '"'), 'utf-8')

        digest_bytes = hmac.new(secret_bytes, msg=event_data_bytes, digestmod=hashlib.sha256).digest()
        return 'SHA256=' + digest_bytes.hex().lower()

if __name__ == "__main__":
    
    # =============== MISP PARTNER (IdP Service) - Start ======================================
    url = 'https://qa-115.mosip.net/idauthentication/v1/internal/callback/partnermanagement/misp_license_generated'
    misp_lic = MISPLicEventDataProvider()
    misp_data = misp_lic.create_event_data()
    auth_header = _build_header(misp_data)

    cus_header = {'accept': 'application/json',
                      'Content-type': 'application/json',
                      'x-hub-signature': auth_header}
    
    resp = requests.post(url, data=misp_data, headers=cus_header) 

    url = 'https://qa-115.mosip.net/idauthentication/v1/internal/callback/partnermanagement/partner_updated'
    partner_data_obj = PartnerEventDataProvider()
    partner_data = partner_data_obj.create_event_data()
    auth_header = _build_header(partner_data)

    cus_header = {'accept': 'application/json',
                      'Content-type': 'application/json',
                      'x-hub-signature': auth_header}
    
    resp = requests.post(url, data=partner_data, headers=cus_header)
    # # =============== MISP PARTNER (IdP Service) - End ======================================

    # # =============== Relying Party PARTNER & OIDC Client - Start ======================================
    url = 'https://qa-115.mosip.net/idauthentication/v1/internal/callback/partnermanagement/oidc_client_created'
    oidc_client = OIDCClientDataProvider()
    oidc_client_data = oidc_client.create_event_data()
    auth_header = _build_header(oidc_client_data)

    cus_header = {'accept': 'application/json',
                      'Content-type': 'application/json',
                      'x-hub-signature': auth_header}
    
    resp = requests.post(url, data=oidc_client_data, headers=cus_header)
    # =============== Relying Party PARTNER & OIDC Client - End ======================================

    print (resp.status_code)
    print (resp.text)
