#!/bin/bash

# Script to compare two files using kdiff3
# Author: https://github.com/kofaysi/
# Description: This script checks the number of input arguments and compares two files using kdiff3 if the correct number of arguments is provided.
# Changelog:
#   - [2025-01-22]: Add function for input count check

# Function to check the number of input arguments
check_input_count() {
    local expected_count=$1
    local actual_count=$#
    local comparison=${2:-"-eq"}

    if ! [ "$actual_count" $comparison "$expected_count" ]; then
        zenity --error --text="Expected $comparison $expected_count arguments, but got $actual_count. Please provide the correct number of inputs."
        exit 1
    fi
}

# Call the function to check input count, expecting exactly 2 arguments
check_input_count 2 -eq "$@"

# Assign the file paths to variables
FILE1="$1"
FILE2="$2"

# Launch kdiff3 to compare the files
kdiff3 "$FILE1" "$FILE2"
