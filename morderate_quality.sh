#!/bin/bash

mkdir -p moderate temp_scan

for pdf in input/*.pdf; do
    name=$(basename "${pdf%.pdf}")

    echo "Processing: $pdf"

    mkdir -p "temp_scan/$name"

    gs -dSAFER -dBATCH -dNOPAUSE \
       -sDEVICE=png16m \
       -r150 \
       -sOutputFile="temp_scan/$name/page_%04d.png" \
       "$pdf"

    i=0

    for page in temp_scan/"$name"/*.png; do

        angle=$(awk -v seed="$RANDOM" \
          'BEGIN{srand(seed); print -1.2 + rand()*2.4}')

        blur=$(awk -v seed="$RANDOM" \
          'BEGIN{srand(seed); print 0.3 + rand()*0.4}')

        magick "$page" \
          -background white \
          -rotate "$angle" \
          -blur "0x$blur" \
          -quality 70 \
          "temp_scan/$name/degraded_$(printf "%04d" "$i").jpg"

        ((i++))
    done

    magick temp_scan/"$name"/degraded_*.jpg \
      "moderate/${name}_moderate.pdf"

    echo "Created: moderate/${name}_moderate.pdf"
done

rm -rf temp_scan

echo "DONE"