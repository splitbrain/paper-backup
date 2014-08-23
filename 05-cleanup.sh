#!/bin/bash

BASE="/tmp"

if [ -z "$1" ]; then
    echo "Usage: $0 <jobid>"
    echo
    echo "Please provide existing jobid as first parameter"
    exit 1
fi

OUTPUT="$BASE/$1"

if [ ! -d "$OUTPUT" ]; then
    echo "jobid does not exist"
    exit 1
fi

rm -rf "$OUTPUT"
