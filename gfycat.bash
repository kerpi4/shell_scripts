#!/bin/bash

# Upload file to gfycat.com using its api
# Dependencies: sensible-browser, curl, jq, dmenu, dunstify

check_status() {
	# Usage: check_status <gfy_name>
	curl -s -X GET https://api.gfycat.com/v1/gfycats/fetch/status/$1
}

gfy_from_file() {
	# Usage: gfy_from_file <file path>

	# get key and upload file
	gfy_name=$(curl -s -XPOST https://api.gfycat.com/v1/gfycats -H "Content-Type: application/json" | jq '.gfyname' | tr -d \")
	cp $1 /tmp/$gfy_name
	curl -s -i https://filedrop.gfycat.com --upload-file /tmp/$gfy_name	

	# check progress
	echo "Encoding. Please wait..."

	while :
       	do
		task=$(check_status $gfy_name | jq '.task' | tr -d \")
		[[ "$task" == "complete" ]] && break
		sleep 5
	done

	# If it exists, it will return gfyId
	gfyId=$(check_status $gfy_name | jq '.gfyId' | tr -d \")
	[[ "$gfyId" == "null" ]] && gfyId=$gfy_name
	echo "Done! Check your browser."
	sensible-browser "https://gfycat.com/"$gfyId

	# clean up
	rm -f /tmp/$gfy_name
}

keep_file() {
	# Choose whether to delete the file using dmenu
	# Usage: keep_file <file path>
	ans=$(echo -e 'Delete File\nMove to MEGASync' | dmenu -b -p Gfycat)
	case $ans in
		Delete*) rm -f $1 && dunstify 'Gfycat' $1' has beed deleted.' ;;
		*MEGASync) mv $1 $HOME/MEGA/MEGA_Pics && dunstify 'Gfycat' $1' backed up.' ;;
	esac
	
}

# check dependecies first
tools=(jq sensible-browser curl dmenu)
for tool in ${tools[@]}; do
	if ! hash $tool &>/dev/null; then
		echo -e 'Can not locate \e[1m'$tool'\e[0m'
		exit 1
	fi
done

# upload the file
if [ -a "$1" ]; then
	gfy_from_file $1
	keep_file $1
else
	echo "Please specify a file."
fi
