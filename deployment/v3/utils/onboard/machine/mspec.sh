#!/bin/sh
# Example script 

SERVER=https://api-internal.sandbox.xyz.net
python3 lib/add_machine_spec.py $SERVER HighEnd LP1 Dell Inspirion "Registration laptop" eng 1.23 admin admin-password
python3 lib/add_machine_spec.py $SERVER HighEnd LP1 Dell Inspirion "Ordinateur portable d'enregistrement" fra 1.23 admin admin-password


