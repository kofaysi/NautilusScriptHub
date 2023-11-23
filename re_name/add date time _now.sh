#!/bin/bash

# Get the current date and time in the desired format
datetime=$(date +"%Y-%m-%d %H%M")

# Iterate over each file or folder provided as input
for item in "$@"; do
    if [[ -f "$item" ]]; then  # Check if the item is a file
        # Extract the filename and extension
        filename=$(basename "$item")
        extension="${filename##*.}"
        filename="${filename%.*}"
        
        # Create the new filename with the current date and time
        new_filename="${datetime} ${filename}"
        
        # Rename the file
        mv "$item" "$new_filename.$extension"
        
        echo "Renamed: $item -> $new_filename.$extension"
    elif [[ -d "$item" ]]; then  # Check if the item is a directory
        # Extract the directory name
        dirname=$(basename "$item")
        
        # Create the new directory name with the current date and time
        new_dirname="${datetime} ${dirname}"
        
        # Rename the directory
        mv "$item" "$new_dirname"
        
        echo "Renamed: $item -> $new_dirname"
    fi
done

