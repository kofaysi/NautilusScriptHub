#!/bin/bash

# Path to the 'names.txt' file
NAMES_FILE="names.txt"

# Check if 'names.txt' exists
if [ ! -f "$NAMES_FILE" ]; then
    echo "names.txt not found"
    exit 1
fi

# Read the file names into an array
readarray -t NEW_NAMES < <(grep . "$NAMES_FILE")

# Check if the number of arguments (selected files) is equal to the number of lines in names.txt
if [ "${#NEW_NAMES[@]}" -ne "$#" ]; then
    echo "The number of files does not match the number of names."
    exit 1
fi

# Rename the files
for i in "$@"; do
    mv "$i" "${NEW_NAMES[0]}"
    NEW_NAMES=("${NEW_NAMES[@]:1}") # Remove the first element from the array
done

