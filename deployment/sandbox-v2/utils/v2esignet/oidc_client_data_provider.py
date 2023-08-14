import json
from datetime import datetime, timedelta
import uuid

class OIDCClientDataProvider(object):


    def __init__(self) -> None:
        self.publisher = 'InfraProviderServiceImpl'
        self.topic = 'OIDC_CLIENT_CREATED'
        pass

    def create_event_data(self) -> str:

        _uuid = str(uuid.uuid4())
        timestamp_now = datetime.utcnow()
        ts_str = timestamp_now.strftime('%Y-%m-%dT%H:%M:%S') + timestamp_now.strftime('.%f')[0:4] + 'Z'
        
        timestamp_now = datetime.utcnow() + timedelta(days=180)
        exp_ts_str = timestamp_now.strftime('%Y-%m-%dT%H:%M:%S') + timestamp_now.strftime('.%f')[0:4] + 'Z'

        partner_data_dict = {}
        partner_data_dict['partnerId'] = 'resident-idp'
        partner_data_dict['partnerName'] = 'IITB'
        partner_data_dict['certificateData'] = '-----BEGIN CERTIFICATE-----\nMIIDsjCCApqgAwIBAgIIXRORMAKU2AYwDQYJKoZIhvcNAQELBQAwcDELMAkGA1UE\nBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUxDTALBgNVBAoM\nBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMRUwEwYDVQQDDAx3d3cu\nbW9zaXAuaW8wHhcNMjIxMjAyMTI0NTQ2WhcNMjUxMjAxMTI0NTQ2WjB7MQswCQYD\nVQQGEwJJTjELMAkGA1UECAwCS0ExEjAQBgNVBAcMCUJBTkdBTE9SRTENMAsGA1UE\nCgwESUlUQjElMCMGA1UECwwcTU9TSVAtVEVDSC1DRU5URVIgKFJFU0lERU5UKTEV\nMBMGA1UEAwwMd3d3Lm1vc2lwLmlvMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB\nCgKCAQEAxE4pm5T/3F7JvOZl1EcsKkmqHVOF8e0R/9VtubXVOl8OejT56hiBr7Lx\ni4sFNbyMoh9+EHxR1JyeSa0bSbvWo0y/KM1rTUhxf8LbIZkKYxm3qjntHo/JzjKA\nhCiOdv7+K6ZuIkGXB2bhqXIIDFtl6zgRqh0WNZlqSZ0Qa3tx7MoXdEJp5q14A9Dy\nyVarpFESfcGYp0TVUw6a801BNttKHnAnNLCWBJto0e6GGyNyL3xuRue+yzGzlp33\n5S5PhPj/TKL2dAVDnfSRdFb8gCFq/Nj6D9GMulHBqRQXE+xvwEvZjpNsaTRY6b2Q\n35GKvV5/vCgrilUxfn9Js5PvzkhzOwIDAQABo0UwQzASBgNVHRMBAf8ECDAGAQH/\nAgEBMB0GA1UdDgQWBBQBp+Y7Rz/jE9AGxo3V3YWdHJ/UjDAOBgNVHQ8BAf8EBAMC\nAoQwDQYJKoZIhvcNAQELBQADggEBAEnpT4k5lElmqRmunsHGXkLmADtFyAqCpe3f\ngEFHq265TIy0fmJSeeEPNBTHNZdhMD1MARR0RhJqstMfJgnEFnm97DcSBeZ3v6bk\nQFyjDVjWsy629xrak4gTpbHuvuzFG7oO8snK1zYPOhHtqhDkmpdhPzwyv+niwahH\n1YkxMpn+UCVSR96TWAFAPORftS42B53XYRG38+cEn/Cl4DEFMlqssDvtXTeNQjoF\n68tyRLxjEfh6DqVtO7iU+EVHF45pr3ZDsorSd9GNOehQhSFDhcYaCLmatg9lp0on\n50PGRo54+M6Y57yu0ya/WhuyxD1JeIXDO5k1XKWc79Jc+5kqnhA=\n-----END CERTIFICATE-----\n'
        partner_data_dict['partnerStatus'] = 'ACTIVE'

        policy_data = {}
        policy_data['policyId'] = 'mpolicy-default-idpservice-main'
        policy_data['policy'] = json.loads('{"authTokenType":"policy","allowedKycAttributes":[{"attributeName":"fullName"},{"attributeName":"gender"},{"attributeName":"phone"},{"attributeName":"postalCode"},{"attributeName":"province"},{"attributeName":"region"},{"attributeName":"zone"},{"attributeName":"email"},{"attributeName":"dateOfBirth"},{"attributeName":"city"},{"attributeName": "face"},{"attributeName":"addressLine3"},{"attributeName":"addressLine2"},{"attributeName":"addressLine1"}],"allowedAuthTypes":[{"authSubType":"IRIS","authType":"bio","mandatory":false},{"authSubType":"FINGER","authType":"bio","mandatory":false},{"authSubType":"","authType":"otp","mandatory":false},{"authSubType":"FACE","authType":"bio","mandatory":false},{"authSubType":"","authType":"otp-request","mandatory":false},{"authSubType":"","authType":"kyc","mandatory":false},{"authSubType":"","authType":"demo","mandatory":false},{"authSubType":"","authType":"kycauth","mandatory":false},{"authSubType":"","authType":"kycexchange","mandatory":false}]}')
        policy_data['policyName'] = 'mpolicy-default-idpservice-desc-main'
        policy_data['policyStatus'] = 'ACTIVE'
        policy_data['policyDescription'] = 'mpolicy-default-esignetservice-desc-main'
        policy_data['policyCommenceOn'] = ts_str
        policy_data['policyExpiresOn'] = exp_ts_str

        oidc_client_data = {}
        oidc_client_data['clientId'] = 'mosip-demo-service-client-idp'
        oidc_client_data['clientName'] = 'Demo Service Client'
        oidc_client_data['clientStatus'] = 'ACTIVE'
        oidc_client_data['userClaims'] = json.loads('["fullName","dateOfBirth","phoneNumber"]')
        oidc_client_data['authContextRefs'] = json.loads('["pin","otp"]')
        oidc_client_data['clientAuthMethods'] = json.loads('["private_key_jwt"]')

        data_dict = {}
        data_dict['partnerData'] = partner_data_dict
        data_dict['policyData'] = policy_data
        data_dict['clientData'] = oidc_client_data
       
        event_data_dict = {}
        event_data_dict['data'] = data_dict
        event_data_dict['dataShareUri'] = None
        event_data_dict['id'] = _uuid
        event_data_dict['timestamp'] = ts_str
        event_data_dict['transactionId'] = None
        event_data_dict['type'] = {'name': 'InfraProviderServiceImpl'}

        final_dict = {}
        final_dict['event'] = event_data_dict
        final_dict['publishedOn'] = ts_str
        final_dict['publisher'] = self.publisher
        final_dict['topic'] = self.topic

        return json.dumps(final_dict)

