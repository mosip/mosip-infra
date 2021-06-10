#!/bin/sh
# Get softhsm PIN
echo Kernel Softhsm PIN: $(kubectl get secret --namespace keymanager softhsm-kernel -o jsonpath="{.data.softhsm-kernel-security-pin}" | base64 --decode)
echo IDA Softhsm PIN: $(kubectl get secret --namespace ida softhsm-ida -o jsonpath="{.data.softhsm-ida-security-pin}" | base64 --decode)
