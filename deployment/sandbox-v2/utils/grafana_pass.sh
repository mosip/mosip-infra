#!/bin/bash
source ~/.bashrc
kc1 get secret --namespace monitoring graf-grafana -o jsonpath="{.data.admin-password}"  | base64 --decode ; echo
