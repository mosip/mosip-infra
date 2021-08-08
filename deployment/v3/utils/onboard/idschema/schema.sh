#!/bin/sh
# Example script to update schema
SERVER=https://api-internal.sandbox.xyz.net
# Admin with GLOBAL_ADMIN role
PASS=<admin password>  
python3 lib/update_idschema.py $SERVER NewSchema "Schema for my country" schemas/ui_spec.json admin $PASS
