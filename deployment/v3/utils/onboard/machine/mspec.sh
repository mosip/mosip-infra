#!/bin/sh
# Example script to add machine specification

SERVER=https://api-internal.sandbox.xyz.net
python3 lib/add_spec.py $SERVER xlsx/spec.xlsx admin admin-password


