#!/bin/bash

# This script requires that you have a dynamodb table variable named "COUNTS_TABLE",
# and that whatever you're running this from is permissioned to write to it.

date="$( date +%s )" #seconds since epoch
counts="$( cat $1 )"
item="{\"date\": {\"N\": \"$date\"}, \"counts\": {\"S\": \"$counts\"} }"
aws dynamodb put-item --table-name game-counts --item "$item"

