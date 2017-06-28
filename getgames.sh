#~/bin/bash

# This will iterate through the steam storefront and gather appids from the html returned.
# category3=1 -- multiplayer
# sort_by=Released_DESC -- sorting by relevance sometimes shifts results around between pages resulting in dupes
# loop terminates when we stop getting appids (error page), or if X > 200 (in case valve changes the results page
# to include appids in a sidebar or something which would trap us forever).  200 is arbitrary but should be fine
# for a while.

# Create file name
date=$(date +"%m-%d-%Y")
outFile="./appids/$date.games"

X=1
keepgoing=1
while (( $keepgoing > 0 && $X < 200 )); do
	games="$(curl -s "http://store.steampowered.com/search/?sort_by=Released_DESC&category3=1&vrsupport=402&page=$X" | sed -n 's/.*appid="\([0-9]\+\).*/\1/p' )"
	if [ "$games" != "" ] 
	then
		echo "$games"
		X=$((X+1))
	else
		keepgoing=0
	fi
done > $outFile
