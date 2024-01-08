#!/bin/bash

# Check if an argument was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <pdf-file>"
    exit 1
fi

# Extract the filename without the extension, handling both lowercase and uppercase extensions
filename=$(basename "$1")
base_name=${filename%%.[pP][dD][fF]}

# Convert PDF to text and extract numbers
pdftotext "$1" - | grep "Váš variabilní symbol je: " | sed -E 's/.*([0-9]{7}).*/\1/' | sort | uniq > "${base_name}-symboly.txt"

echo "Output written to ${base_name}-symboly.txt"

