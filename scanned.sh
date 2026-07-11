#!/bin/bash

mkdir -p scanned

for pdf in input/*.pdf; do
    name=$(basename "${pdf%.pdf}")

    echo "Processing: $pdf"

    gs -dSAFER -dBATCH -dNOPAUSE \
       -sDEVICE=pdfimage24 \
       -r200 \
       -sOutputFile="scanned/${name}_scanned.pdf" \
       "$pdf"

    echo "Created: scanned/${name}_scanned.pdf"
done

echo "DONE"