#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 file1.pdf file2.pdf [file3.pdf ... fileN.pdf]"
    exit 1
fi

# Store the name of the first input file (without extension) for renaming later
first_input_file=$(basename "$1" .pdf)

# Output file name - temporary name
output_file="merged_temp.pdf"

# Merge the PDF files using Ghostscript
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$output_file" "$@"

# Check if the merging was successful
if [ $? -eq 0 ]; then
    # Delete the input files
    for file in "$@"; do
        rm "$file"
    done

    # Rename the merged file to the name of the first input file
    mv "$output_file" "${first_input_file}.pdf"

    echo "PDF files have been merged and renamed to ${first_input_file}.pdf"
else
    echo "An error occurred while merging the PDF files"
    exit 1
fi

