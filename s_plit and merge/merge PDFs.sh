#!/bin/bash

# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 file1.pdf file2.pdf [file3.pdf ... fileN.pdf]"
    exit 1
fi

# Base output file name
base_output_file="merged"
output_file="${base_output_file}.pdf"
counter=1

# Increment filename if the output file already exists
while [ -e "$output_file" ]; do
    printf -v output_file "%s%03d.pdf" "$base_output_file" "$counter"
    ((counter++))
done

# Merge the PDF files using Ghostscript
gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$output_file" "$@"

# Check if the merging was successful
if [ $? -eq 0 ]; then
    echo "PDF files have been merged into $output_file"
else
    echo "An error occurred while merging the PDF files"
    exit 1
fi

