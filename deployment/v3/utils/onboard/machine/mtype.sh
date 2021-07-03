#!/bin/sh
# Example script 

SERVER=https://api-internal.sandbox.xyz.net
python3 lib/add_machine_type.py $SERVER LP1 Laptop-1 "Nice looking laptop" eng admin <password>
python3 lib/add_machine_type.py $SERVER LP1 Laptop-1 "Joli ordinateur portable" fra admin <password>
