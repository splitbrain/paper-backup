#!/bin/bash

LANGUAGE="deu" # the tesseract language
BASE="/tmp"

if [ -z "$1" ]; then
    echo "Usage: $0 <jobid>"
    echo
    echo "Please provide existing jobid as first parameter"
    exit 1
fi

OUTPUT="$BASE/$0"

if [ -d "$OUTPUT" ]; then
    echo "jobid does not exist"
    exit 1
fi

cd "$OUTPUT"

# cut borders 
for i in scan_*.pnm; do
    mogrify -shave 50x5 "${i}"
done

# check if the page is blank
# http://philipp.knechtges.com/?p=190
echo 'checking for blank pages...'
for i in scan_*.pnm; do
    echo "${i}"
    histogram=`convert "${i}" -threshold 50% -format %c histogram:info:-`
    white=`echo "${histogram}" | grep "#FFFFFF" | sed -n 's/^ *\(.*\):.*$/\1/p'`
    black=`echo "${histogram}" | grep "#000000" | sed -n 's/^ *\(.*\):.*$/\1/p'`
    blank=`echo "scale=4; ${black}/${white} < 0.005" | bc`

    if [ ${blank} -eq "1" ]; then
        echo "${i} seems to be blank - removing it..."
        rm "${i}"
    fi
done

# apply text cleaning and convert to tif
echo 'cleaning pages...'
for i in scan_*.pnm; do
    echo "${i}"
    convert "${i}" -contrast-stretch 1% -level 29%,76% "${i}.tif"
done

# do OCR
echo 'doing OCR...'
for i in scan_*.pnm.tif; do
    echo "${i}"
    tesseract "$i" "$i" -l $LANGUAGE hocr
    hocr2pdf -i "$i" -s -o "$i.pdf" < "$i.html"
done

# create PDF
echo 'creating PDF...'
pdftk *.tif.pdf cat output "$1.pdf"

echo "created $OUTPUT/$1.pdf"
