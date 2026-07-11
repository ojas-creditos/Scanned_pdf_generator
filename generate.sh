#!/bin/bash

MODE=$1

if [[ -z "$MODE" ]]; then
    echo "Usage: ./generate.sh [scanned|moderate|poor|all]"
    exit 1
fi

generate_scanned() {
    mkdir -p scanned

    for pdf in input/*.pdf; do
        name=$(basename "${pdf%.pdf}")

        echo "Scanning: $pdf"

        gs -dSAFER -dBATCH -dNOPAUSE \
           -sDEVICE=pdfimage24 \
           -r200 \
           -sOutputFile="scanned/${name}_scanned.pdf" \
           "$pdf"
    done
}

generate_degraded() {
    QUALITY=$1
    DPI=$2
    MIN_ANGLE=$3
    ANGLE_RANGE=$4
    MIN_BLUR=$5
    BLUR_RANGE=$6
    JPEG_QUALITY=$7

    mkdir -p "$QUALITY"
    workroot=$(mktemp -d)

    for pdf in input/*.pdf; do
        name=$(basename "${pdf%.pdf}")
        workdir="$workroot/$name"

        echo "Generating $QUALITY: $pdf"

        mkdir -p "$workdir"

        gs -dSAFER -dBATCH -dNOPAUSE \
           -sDEVICE=png16m \
           -r"$DPI" \
           -sOutputFile="$workdir/page_%04d.png" \
           "$pdf"

        i=0

        for page in "$workdir"/page_*.png; do
            angle=$(awk -v seed="$RANDOM" \
              -v min="$MIN_ANGLE" -v range="$ANGLE_RANGE" \
              'BEGIN{srand(seed); print min + rand()*range}')

            blur=$(awk -v seed="$RANDOM" \
              -v min="$MIN_BLUR" -v range="$BLUR_RANGE" \
              'BEGIN{srand(seed); print min + rand()*range}')

            magick "$page" \
              -background white \
              -rotate "$angle" \
              -blur "0x$blur" \
              -quality "$JPEG_QUALITY" \
              "$workdir/degraded_$(printf "%04d" "$i").jpg"

            ((i++))
        done

        magick "$workdir"/degraded_*.jpg \
          "$QUALITY/${name}_${QUALITY}.pdf"
    done

    rm -rf "$workroot"
}

case "$MODE" in
    scanned)
        generate_scanned
        ;;

    moderate)
        generate_degraded moderate 150 -1.2 2.4 0.3 0.4 70
        ;;

    poor)
        generate_degraded poor 90 -3 6 1.0 1.0 35
        ;;

    all)
        generate_scanned
        generate_degraded moderate 150 -1.2 2.4 0.3 0.4 70
        generate_degraded poor 90 -3 6 1.0 1.0 35
        ;;

    *)
        echo "Invalid mode: $MODE"
        echo "Usage: ./generate.sh [scanned|moderate|poor|all]"
        exit 1
        ;;
esac

echo "DONE: $MODE"