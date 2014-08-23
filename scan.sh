#!/bin/bash

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
JOBID=`date '+%Y-%m-%d_%H%M%S'`
USER=$1
KEYWORD=$2

if [ -z "$USER" ]; then
    echo "Usage: $0 <user> [<keyword>]"
    echo "please give a user"
    exit 1
fi


# run the scanning in foreground
$DIR/01-scan.sh "$JOBID"

# execute processing in background
(
    # lock processing to make sure only one is running at a time
    (
        flock -x 200 # wait for lock

        $DIR/02-createpdf.sh "$JOBID"
        $DIR/03-nascopy.sh "$JOBID" "$USER" "$KEYWORD"
        $DIR/04-gdrivecopy.sh "$JOBID" "$USER" "$KEYWORD"
        $DIR/05-cleanup.sh "$JOBID"

    ) 200>/tmp/scan.lock
) &


