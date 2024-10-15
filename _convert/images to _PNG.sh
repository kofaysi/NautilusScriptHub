#!/bin/bash

# Check if ImageMagick's convert command is available
if ! command -v convert &> /dev/null
then
    zenity --error --text="ImageMagick is not installed. Please install it first."
    exit 1
fi

# Iterate over each selected file
for FILE in "$@"
do
    # Get the file's directory, name without extension, and extension
    DIR=$(dirname "$FILE")
    BASENAME=$(basename "$FILE")
    NAME="${BASENAME%.*}"
    EXT="${BASENAME##*.}"

    # Convert the file to PNG format
    OUTPUT="$DIR/$NAME.png"
    convert "$FILE" "$OUTPUT"

    # Check if the conversion was successful
    if [ $? -ne 0 ]; then
        zenity --error --text="Failed to convert $BASENAME."
    fi
done

