#!/bin/bash
# Config server encryption key. 
# NOTE: Needed if you encrypt data and hardcode it in the property files.
echo Config server encryption key: $(kubectl get secret --namespace config-server config-server -o jsonpath="{.data.encrypt-key}" | base64 --decode)
