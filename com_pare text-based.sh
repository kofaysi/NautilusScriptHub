#!/bin/bash

# Check if exactly two file paths are provided
if [ "$#" -ne 2 ]; then
    zenity --error --text="Please select exactly two files to compare."
    exit 1
fi

# Assign the file paths to variables
FILE1="$1"
FILE2="$2"

# Launch kdiff3 to compare the files
kdiff3 "$FILE1" "$FILE2"

