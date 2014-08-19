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

OUTPUT="$BASE/$0"
REMOTE="$2://$FOLDER/$keyword/"
LOCAL="$OUTPUT/$1.pdf"

if [ -f "$LOCAL" ]; then
    echo "jobid does not exist"
    exit 1
fi

rclone copy "$LOCAL" "$REMOTE"

