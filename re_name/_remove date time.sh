#!/bin/bash

# Iterate over each file or folder provided as input
for item in "$@"; do
    if [[ -e "$item" ]]; then  # Check if the item exists
        # Extract the base name and directory path
        base=$(basename "$item")
        dir=$(dirname "$item")

        # Determine if the item is a file or a directory
        if [[ -f "$item" ]]; then
            # Extract the filename and extension
            filename="${base%.*}"
            extension="${base##*.}"

            # Remove the date, time, and trailing space from the beginning of the filename
            new_filename="${filename#????-??-?? ???? }"

            # Rename the file
            mv "$item" "${dir}/${new_filename}.${extension}"

            echo "Renamed: $item -> ${dir}/${new_filename}.${extension}"
        elif [[ -d "$item" ]]; then
            # Remove the date, time, and trailing space from the beginning of the directory name
            new_dirname="${base#????-??-?? ???? }"

            # Rename the directory
            mv "$item" "${dir}/${new_dirname}"

            echo "Renamed: $item -> ${dir}/${new_dirname}"
        fi
    else
        echo "File or directory not found: $item"
    fi
done

