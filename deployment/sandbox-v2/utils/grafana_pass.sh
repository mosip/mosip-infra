#!/bin/bash
source ~/.bashrc
kc1 get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}"  | base64 --decode ; echo
