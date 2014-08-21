#!/bin/bash

BASE="/tmp"
FOLDER="documents"

if [ -z "$1" ]; then
    echo "Usage: $0 <jobid> <user> [<keyword>]"
    echo
    echo "Please provide existing jobid as first parameter"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Usage: $0 <jobid> <user> [<keyword>]"
    echo
    echo "Please provide user as second parameter"
    exit 1
fi

OUTPUT="$BASE/$1"
REMOTE="$2://$FOLDER/$3/"
LOCAL="$OUTPUT/$1.pdf"

if [ ! -f "$LOCAL" ]; then
    echo "jobid does not exist"
    exit 1
fi

for X in 1 2 3; do
   echo "uploading to Google Drive (try $X)"
   if rclone --config=$HOME/.rclone.conf copy "$LOCAL" "$REMOTE"; then
       exit 0
   fi
   sleep 15 # wait 15 seconds before retrying
done
exit 1
