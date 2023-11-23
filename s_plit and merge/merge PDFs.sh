#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 file1.pdf file2.pdf [file3.pdf ... fileN.pdf]"
    exit 1
fi

# Output file name
output_file="merged.pdf"

# Merge the PDF files using Ghostscript
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$output_file" "$@"

# Check if the merging was successful
if [ $? -eq 0 ]; then
    echo "PDF files have been merged into $output_file"
else
    echo "An error occurred while merging the PDF files"
    exit 1
fi

