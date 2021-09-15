#!/bin/bash
# Example script to add a machine

SERVER=https://api-internal.v3box1.mosip.net
python3 lib/add_machine.py $SERVER xlxs/machine.xlsx eng admin <password>
