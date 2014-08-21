#!/bin/bash

BASE="/tmp"

if [ -z "$1" ]; then
    echo "Usage: $0 <jobid>"
    echo
    echo "Please provide unique jobid name as first parameter"
    exit 1
fi

OUTPUT="$BASE/$1"
mkdir -p "$OUTPUT"

echo 'scanning...'
scanimage --resolution 300 \
	  --batch="$OUTPUT/scan_%03d.pnm" \
          --format=pnm \
          --mode Gray \
          --source 'ADF Duplex' 
echo "Output in $OUTPUT/scan*.pnm"
