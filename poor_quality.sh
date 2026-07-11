#!/bin/bash

mkdir -p poor temp_scan

for pdf in input/*.pdf; do
    name=$(basename "${pdf%.pdf}")

    echo "Processing: $pdf"

    mkdir -p "temp_scan/$name"

    gs -dSAFER -dBATCH -dNOPAUSE \
       -sDEVICE=png16m \
       -r90 \
       -sOutputFile="temp_scan/$name/page_%04d.png" \
       "$pdf"

    i=0

    for page in temp_scan/"$name"/*.png; do

        angle=$(awk -v seed="$RANDOM" \
          'BEGIN{srand(seed); print -3 + rand()*6}')

        blur=$(awk -v seed="$RANDOM" \
          'BEGIN{srand(seed); print 1.0 + rand()*1.0}')

        magick "$page" \
          -background white \
          -rotate "$angle" \
          -blur "0x$blur" \
          -brightness-contrast "-8x-15" \
          -attenuate 0.08 \
          +noise Gaussian \
          -quality 35 \
          "temp_scan/$name/degraded_$(printf "%04d" "$i").jpg"

        ((i++))
    done

    magick temp_scan/"$name"/degraded_*.jpg \
      "poor/${name}_poor.pdf"

    echo "Created: poor/${name}_poor.pdf"
done

rm -rf temp_scan

echo "DONE"
