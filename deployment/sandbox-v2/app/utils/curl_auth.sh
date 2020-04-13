# The ip
INGRESS_IP=10.6.1.125
curl -d '{"id": "mosip.authentication.useridPwd", "metadata": {}, "request": { "appId": "mosip", "password": "puneet123", "userName": "puneet" }, "requesttime": "2020-04-12T06:12:52.994Z", "version": "1.0" }' -H "Content-Type: application/json" -X POST http://$INGRESS_IP/v1/authmanager/authenticate/useridPwd 
