#!/bin/sh
# Installs all kernel helm charts 
helm repo update
helm -n keymanager install keymanager mosip/keymanager
helm -n kernel install authmanager mosip/authmanager
helm -n kernel install auditmanager mosip/auditmanager
helm -n kernel install idgenerator mosip/idgenerator  
helm -n kernel install masterdata mosip/masterdata
helm -n kernel install otpmanager mosip/otpmanager
helm -n kernel install pridgenerator mosip/pridgenerator
helm -n kernel install ridgenerator mosip/ridgenerator
helm -n kernel install syncdata mosip/syncdata
