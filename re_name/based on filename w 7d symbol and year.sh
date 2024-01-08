#!/bin/bash

# Define the full path to the hash generator script
HASH_GENERATOR_SCRIPT="$HOME/.local/share/nautilus/scripts/re_name/S523 7d symbol to 7c hash.sh"

# Function to extract 7-digit number and 4-digit year from a filename
extract_numbers() {
    local filename="$1"
    local seven_digit_regex=' ([0-9]{7})(\.| |$)'
    local year_regex=' ([0-9]{4})(\.| |$)'

    if [[ $filename =~ $seven_digit_regex ]]; then
        seven_digit="${BASH_REMATCH[1]}"
    else
        exit 1
    fi

    if [[ $filename =~ $year_regex ]]; then
        year="${BASH_REMATCH[1]}"
    else
        exit 1
    fi
}

# Function to generate hash using the hash generator script
generate_hash() {
    local number="$1"
    
    if [ ! -f "$HASH_GENERATOR_SCRIPT" ]; then
        exit 1
    fi

    hash_output=$(bash "$HASH_GENERATOR_SCRIPT" "$number")
    echo "$hash_output"
}

# Loop over each provided file
for file in "$@"; do
    if [ ! -f "$file" ]; then
        continue
    fi

    extract_numbers "$file"
    hash=$(generate_hash "$seven_digit")
    if [ -z "$hash" ]; then
        exit 1
    fi
    target_dir="${seven_digit} ${hash}/${year}"
    mkdir -p "$target_dir"
    mv "$file" "$target_dir/$file"
done

