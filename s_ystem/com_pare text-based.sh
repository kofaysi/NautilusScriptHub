#!/bin/bash

# Script to compare two files using kdiff3
# Author: https://github.com/kofaysi/
# Description: This script checks the number of input arguments and compares two files using kdiff3 if the correct number of arguments is provided.
# Changelog:
# - [2025-01-22]: Add function for input count check
# - [2025-01-25]: Import common functions from script_utils.sh

# import common script functions
if [ -f ~/.local/share/nautilus/scripts/script_utils.sh ]; then
    source ~/.local/share/nautilus/scripts/script_utils.sh
else
    echo "Error: script_utils.sh not found. Exiting."
    exit 1
fi

# Call the function to check input count, expecting exactly 2 arguments
check_input_count 2 -eq "$@"

# Assign the file paths to variables
FILE1="$1"
FILE2="$2"

# Launch kdiff3 to compare the files
kdiff3 "$FILE1" "$FILE2"
