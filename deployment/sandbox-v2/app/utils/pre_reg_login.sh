# The ip
INGRESS_IP=10.6.1.125
curl -d '{ "id": "mosip.pre-registration.login.sendotp", "version": "1.0", "requesttime": "2020-04-06T07:24:47.605Z", "request": { "userId": "puneet.joshi007@gmail.com" } }' -H "Content-Type: application/json" -X POST http://$INGRESS_IP/preregistration/v1/login/sendOtp
