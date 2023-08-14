import json
from datetime import datetime, timedelta
import uuid

class PartnerEventDataProvider(object):


    def __init__(self) -> None:
        self.publisher = 'InfraProviderServiceImpl'
        self.topic = 'PARTNER_UPDATED'
        pass

    def create_event_data(self) -> str:

        _uuid = str(uuid.uuid4())
        timestamp_now = datetime.utcnow()
        ts_str = timestamp_now.strftime('%Y-%m-%dT%H:%M:%S') + timestamp_now.strftime('.%f')[0:4] + 'Z'
        
        partner_data = {}
        partner_data['partnerId'] = 'mpartner_default_idp_service_newqa'
        partner_data['partnerName'] = 'IdP Service'
        partner_data['certificateData'] = '-----BEGIN CERTIFICATE-----\nMIIDvTCCAqWgAwIBAgIIjYpq+AJQXlAwDQYJKoZIhvcNAQELBQAwdzELMAkGA1UE\nBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUxDTALBgNVBAoM\nBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMRwwGgYDVQQDDBN3d3cu\nbW9zaXAuaW8gKFJPT1QpMB4XDTIzMDcyNzEyMjMwMFoXDTI2MDcyNjEyMjMwMFow\nfzELMAkGA1UEBhMCSU4xCzAJBgNVBAgMAktBMRIwEAYDVQQHDAlCQU5HQUxPUkUx\nDTALBgNVBAoMBElJVEIxGjAYBgNVBAsMEU1PU0lQLVRFQ0gtQ0VOVEVSMSQwIgYD\nVQQDDBt3d3cubW9zaXAuaW8gKE9JRENfUEFSVE5FUikwggEiMA0GCSqGSIb3DQEB\nAQUAA4IBDwAwggEKAoIBAQDNo0F+aMP1dTYsM3IVxZGRGSu4rQJ22TCQo5ns0khh\nz7Kj+7vlLhiz+oa3YFU5Kt1vDdJTVj3gXgt5IE2TiIDil6uJT+YfkM7KhdaHoUSH\nQuiUFCVGyXcUIyDDu1/cD3yX1Fpf9V8pB5uG3Mxk/GlXHAwmS+W7tABAAiFcnnjo\naS9RgIqDEi6BU9hvhevwvk3iWEXOK0Hh9ptgLjtmwDKADPJQDZjz3gDqauMDAarv\nhy71v5Mk3FZx17Y1LMsl+unXgsMD/V7b2HdmWmhLpZwg6SsYhq4aYBMt3X3Y7i9B\nqe5RHWyOJPZxmuypVIMlgN+uxsyXHxhjQdMbPQDYjm6PAgMBAAGjRTBDMBIGA1Ud\nEwEB/wQIMAYBAf8CAQEwHQYDVR0OBBYEFAc/61n+Rg1QaFu0Ezb5cC+vgTYnMA4G\nA1UdDwEB/wQEAwIChDANBgkqhkiG9w0BAQsFAAOCAQEAMElGmD+IlDJtYT4xTyCp\ngRkqMi78hE0C39GmQrHgceJPjseVE0U2db/IzFZCjTObd8MPstcvxNO1BmeKVChw\n45g+vKvgEuGrncUNeVIRxwvQFFoIvtL/v83jceDhHx4OM6aiQRZJxyUMnNw2NFXe\nPM43tCUH0Uq+2X6HD18Y6MzuIjd6fJN2ceMsfZOMQlPOJFI+R7lEZ0NQ8WhIWyUv\nM8MpSFPLVPtu+X3Upzlu938wS48mu/jkLUDcWeY0aiAVzrT3wqzrp02rw6Xswdhj\nVkoNix+1BfbjUklegOVArhXwqnJ7JKtU831+oO/mfEv5V4g0jgKar6rphmFkNFAp\nhQ==\n-----END CERTIFICATE-----\n'
        partner_data['partnerStatus'] = 'ACTIVE'

        data_dict = {}
        data_dict['partnerData'] = partner_data
       
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
