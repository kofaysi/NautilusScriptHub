#!/bin/bash

# Check if at least one argument is given
if [ $# -eq 0 ]; then
    echo "Usage: $0 <image1> <image2> ..."
    exit 1
fi

for image in "$@"
do
    # Check if file exists
    if [ ! -f "$image" ]; then
        echo "File $image does not exist."
        continue
    fi

    # File name and extension manipulation
    filename="${image%%.*}"
    extension="${image##*.}"

    # Perform operations in sequence and create a final image
    # 1. Edge detection
    # 2. Colour inversion
    # 3. Image enhancement
    # 4. Convert to B&W
    convert "$image" \
            -edge 1 \
            -negate \
            -auto-level \
            -colorspace Gray \
            "${filename}_conv.${extension}"

    echo "Processed $image into ${filename}_conv.${extension}"
done

echo "All operations completed."

