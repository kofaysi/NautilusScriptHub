#!/bin/bash

# Loop through all input images
for file in "$@"; do
    # Skip if the file is not a JPG or PNG
    [[ "$file" =~ \.jpg$|\.JPG$|\.png$|\.PNG$ ]] || continue

    # Get the directory, base name, and extension of the image
    dir_name=$(dirname "$file")
    base_name=$(basename "$file")
    extension="${base_name##*.}"
    file_name="${base_name%.*}"
    
    # New file name with "-original" added
    original_file_name="$dir_name/$file_name-original.$extension"
    
    # Rename the original image
    mv "$file" "$original_file_name"
    
    # Resize the image to make the longest side 1800 pixels and set resolution to 150 ppi
    convert "$original_file_name" -resize 1800x1800 -density 150 -units PixelsPerInch "$file"
done

echo "All JPG and PNG files have been resized"

