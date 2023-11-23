#!/bin/bash

# Iterate over each file or folder provided as input
for item in "$@"; do
    if [[ -e "$item" ]]; then  # Check if the item exists
        # Extract the base name and directory path
        base=$(basename "$item")
        dir=$(dirname "$item")

        # Determine if the item is a file or a directory
        if [[ -f "$item" ]]; then
            # Extract the creation timestamp of the file
            timestamp=$(stat -c %y "$item")

            # Convert the timestamp to the desired format (YYYY-MM-DD HHMM)
            datetime=$(date -d "$timestamp" +"%Y-%m-%d %H%M")

            # Extract the filename and extension
            filename="${base%.*}"
            extension="${base##*.}"

            # Create the new filename with the creation date and time
            new_filename="${datetime} ${filename}"

            # Rename the file
            mv "$item" "${dir}/${new_filename}.${extension}"

            echo "Renamed: $item -> ${dir}/${new_filename}.${extension}"
        elif [[ -d "$item" ]]; then
            # Extract the creation timestamp of the directory
            timestamp=$(stat -c %y "$item")

            # Convert the timestamp to the desired format (YYYY-MM-DD HHMM)
            datetime=$(date -d "$timestamp" +"%Y-%m-%d %H%M")

            # Create the new directory name with the creation date and time
            new_dirname="${datetime} ${base}"

            # Rename the directory
            mv "$item" "${dir}/${new_dirname}"

            echo "Renamed: $item -> ${dir}/${new_dirname}"
        fi
    else
        echo "File or directory not found: $item"
    fi
done

