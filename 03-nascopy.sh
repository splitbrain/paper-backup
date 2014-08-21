#!/bin/bash

BASE="/tmp"
HOST="diskstation"
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
REMOTE="sftp://$2@$HOST/home/$FOLDER/$3/$1.pdf"
LOCAL="$OUTPUT/$1.pdf"

if [ ! -f "$LOCAL" ]; then
    echo "jobid does not exist"
    exit 1
fi


echo copying to $REMOTE
curl --ftp-create-dirs --insecure -T "$LOCAL" "$REMOTE"

