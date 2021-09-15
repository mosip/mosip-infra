#!/bin/bash
# Get artemis admin password
echo Password: $(kubectl -n activemq get secret activemq-activemq-artemis -o jsonpath="{.data.artemis-password}" | base64 --decode)
