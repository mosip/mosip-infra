#!/bin/sh
# Example script 

SERVER=https://api-internal.sandbox.xyz.net
python3 lib/add_machine_spec.py $SERVER xlsx/spec.xlsx admin admin-password


