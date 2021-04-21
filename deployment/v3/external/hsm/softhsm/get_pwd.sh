#!/bin/sh
# Get softhsm PIN
echo PIN: $(kubectl get secret --namespace softhsm softhsm-kernel -o jsonpath="{.data.softhsm-kernel-security-pin}" | base64 --decode)
