#!/bin/sh
# Example script 

SERVER=https://api-internal.sandbox.xyz.net
python3 lib/add_machine_type.py $SERVER xlxs/type.xlsx admin <password>
