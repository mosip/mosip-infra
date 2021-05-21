#!/bin/sh
# Installs all PreReg helm charts 
helm repo update
kubectl create ns prereg
helm -n prereg install prereg-application mosip/prereg-application 
helm -n prereg install prereg-batchjob mosip/prereg-batchjob
helm -n prereg install prereg-booking mosip/prereg-booking
helm -n prereg install prereg-datasync mosip/prereg-datasync
