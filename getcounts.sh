#!/bin/bash

# This requires that you have a Steam API key exported to a variable named "STEAMKEY"
# Loops through all lines in input file (first argument - one appid per line), gets the player count,
# then add it to a string containing appid:count pairs separated by a comma.  I don't care to remove the last comma

while read appid; do
	count="$(curl -s "https://api.steampowered.com/ISteamUserStats/GetNumberOfCurrentPlayers/v1/?key=$STEAMKEY&format=json&appid=$appid" | sed -n 's/.*count": \(.*\+\),/\1/p' )"
	echo -n "$appid:$count,"
done <$1 >$2
