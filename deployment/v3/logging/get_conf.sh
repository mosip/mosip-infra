#!/bin/bash
# Get fluentd.conf  and fluent.conf
echo fluentd.conf: $(kubectl get secret --namespace cattle-logging-system rancher-logging-eks-fluentd-app -o jsonpath="{.data.fluentd\.conf}" | base64 --decode)
echo ''
echo fluent.conf: $(kubectl get secret --namespace cattle-logging-system rancher-logging-eks-fluentd -o jsonpath="{.data.fluent\.conf}" | base64 --decode)
