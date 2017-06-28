#!/bin/bash

FILE=$1

while read appid; do
	item="{\"appid\": {\"N\": \"$appid\"}}"
	aws dynamodb put-item --table-name multiplayer-games --item "$item"
done <$FILE
