#!/bin/sh
# Convert a cert to a single line
# ./single_line.sh <pem_path>

awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' $1
