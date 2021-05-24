#!/bin/sh
# Installs all kernel helm charts 
helm repo update
echo "Installing keymanager"
helm -n keymanager install keymanager mosip/keymanager
echo "Installing authmanager"
helm -n kernel install authmanager mosip/authmanager
echo "Installing auditmanager"
helm -n kernel install auditmanager mosip/auditmanager
echo "Installing idgenerator"
helm -n kernel install idgenerator mosip/idgenerator  
echo "Installing masterdata"
helm -n kernel install masterdata mosip/masterdata
echo "Installing otpmanager"
helm -n kernel install otpmanager mosip/otpmanager
echo "Installing pridgenerator"
helm -n kernel install pridgenerator mosip/pridgenerator
echo "Installing ridgenerator"
helm -n kernel install ridgenerator mosip/ridgenerator
echo "Installing syncdata"
helm -n kernel install syncdata mosip/syncdata
