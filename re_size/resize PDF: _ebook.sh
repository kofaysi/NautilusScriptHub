#!/bin/bash

# Loop through all input PDFs
for file in "$@"; do
    # Skip if the file is not a PDF
    [[ "$file" =~ \.pdf$|\.PDF$ ]] || continue

    # Get the directory, base name, and extension of the PDF
    dir_name=$(dirname "$file")
    base_name=$(basename "$file")
    extension="${base_name##*.}"
    file_name="${base_name%.*}"
    
    # New file name with "-original" added
    original_file_name="$dir_name/$file_name-original.$extension"
    
    # Rename the original PDF
    mv "$file" "$original_file_name"
    
    # Use Ghostscript to resize the PDF
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$file" -f "$original_file_name"
done

echo "All PDF files have been resized"

