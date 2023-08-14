import json
from datetime import datetime, timedelta
import uuid

class MISPLicEventDataProvider(object):


    def __init__(self) -> None:
        self.publisher = 'InfraProviderServiceImpl'
        self.topic = 'MISP_LICENSE_GENERATED'
        pass

    def create_event_data(self) -> str:

        _uuid = str(uuid.uuid4())
        timestamp_now = datetime.utcnow()
        ts_str = timestamp_now.strftime('%Y-%m-%dT%H:%M:%S') + timestamp_now.strftime('.%f')[0:4] + 'Z'
        
        timestamp_now = datetime.utcnow() + timedelta(days=180)
        exp_ts_str = timestamp_now.strftime('%Y-%m-%dT%H:%M:%S') + timestamp_now.strftime('.%f')[0:4] + 'Z'
        
        misp_lic_data = {}
        misp_lic_data['mispId'] = 'mpartner_default_idp_service_newqa'
        misp_lic_data['licenseKey'] = 'WC9egXBuXhqxl4bPZ7rr5AzoSNFgcB0vapVonPozkEC9Wed9EU'
        misp_lic_data['mispCommenceOn'] = ts_str
        misp_lic_data['mispExpiresOn'] = exp_ts_str
        misp_lic_data['mispStatus'] = 'ACTIVE'

        policy_data = {}
        policy_data['policyId'] = '6887'
        policy_data['policy'] = json.loads('{"allowKycRequestDelegation":"true","allowOTPRequestDelegation":"true"}')
        policy_data['policyName'] = 'mosip idp policy 166319887388'
        policy_data['policyStatus'] = 'ACTIVE'
        policy_data['policyDescription'] = 'desc mosip idp policy new'
        policy_data['policyCommenceOn'] = ts_str
        policy_data['policyExpiresOn'] = exp_ts_str

        data_dict = {}
        data_dict['mispLicenseData'] = misp_lic_data
        data_dict['policyData'] = policy_data
       
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
