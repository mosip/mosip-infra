#!/bin/bash
# Example script to add machine type

SERVER=https://api-internal.v3box1.mosip.net
python3 lib/add_type.py $SERVER xlxs/type.xlsx admin <password>
