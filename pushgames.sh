#!/bin/bash

FILE=$1

while read appidAndName; do
	appid=${appidAndName%%|*}
	name=${appidAndName#*|}
	item="{\"appid\": {\"N\": \"$appid\"}, \"name\": {\"S\": \"$name\"}}"
	aws dynamodb put-item --table-name multiplayer-games --item "$item"
done <$FILE
