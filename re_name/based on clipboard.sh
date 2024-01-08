#!/bin/bash

# Read the file names from the clipboard, ignoring empty lines
readarray -t NEW_NAMES < <(xclip -o | grep .)

# Check if the clipboard content is empty
if [ ${#NEW_NAMES[@]} -eq 0 ]; then
    echo "No names found in the clipboard."
    exit 1
fi

# Check if the number of arguments (selected files) is equal to the number of non-empty lines in clipboard
if [ "${#NEW_NAMES[@]}" -ne "$#" ]; then
    echo "The number of files does not match the number of names."
    exit 1
fi

# Rename the files
for i in "$@"; do
    mv "$i" "${NEW_NAMES[0]}"
    NEW_NAMES=("${NEW_NAMES[@]:1}") # Remove the first element from the array
done

