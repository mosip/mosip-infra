# The ip
INGRESS_URL=http://kubeworker1:30080
curl -d '{"id": "mosip.authentication.useridPwd", "metadata": {}, "request": { "appId": "mosip", "password": "testuser", "userName": "testuser" }, "requesttime": "2020-04-12T06:12:52.994Z", "version": "1.0" }' -H "Content-Type: application/json" -X POST $INGRESS_URL/v1/authmanager/authenticate/useridPwd 
