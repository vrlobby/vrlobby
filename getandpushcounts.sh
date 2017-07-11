#!/bin/bash

# This requires that you have a Steam API key exported to a variable named "STEAMKEY"
# Loops through all lines in input file (first argument - one appid per line), gets the player count,
# then add it to a string containing appid:count pairs separated by a comma.  I don't care to remove the last comma
# This script also requires that you have a dynamodb table variable named "COUNTS_TABLE",
# and that whatever you're running this from is permissioned to write to it.

source ./setenv.sh

# Get most recent file from appids directory
appids=$(ls -dt ./appids/* | head -1)

fileDate=$(date +"%m-%d-%y_%H-%M")
outFile="./counts/$fileDate.counts"
datetime="$( date +%s )" #seconds since epoch
date=$(date +"%Y%m%d")
hour=$(date +"%H")
mins=$(date +"%M")
quarter=$(( $mins / 15 ))

while read appid; do
	count="$(curl -s "https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1/?key=$STEAMKEY&format=json&appid=$appid" | sed -n 's/.*count": \(.*\+\),/\1/p' )"
	echo -n "$appid:$count,"
done <$appids >$outFile

counts="$( cat $outFile )"
item="{\"date\": { \"S\": \"$date\"}, \"datetime\": { \"N\": \"$datetime\"}, \"hour\": { \"N\": \"$hour\"}, \"quarter\": { \"N\": \"$quarter\"}, \"counts\": {\"S\": \"$counts\"} }"
aws dynamodb put-item --table-name "$COUNTS_TABLE" --item "$item"

