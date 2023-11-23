#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 file1.pdf [file2.pdf ... fileN.pdf]"
    exit 1
fi

# Create a temporary directory for processing
temp_dir=$(mktemp -d)
trap "rm -rf $temp_dir" EXIT

# Loop through all input PDFs
for file in "$@"; do
    # Skip if the file is not a PDF
    [[ "$file" =~ \.pdf$|\.PDF$ ]] || continue

    # Copy the file to the temporary directory with a sanitized name
    temp_file="$temp_dir/temp.pdf"
    cp "$file" "$temp_file"

    # Get the directory, base name, and extension of the PDF
    dir_name=$(dirname "$file")
    base_name=$(basename "$file")
    file_name="${base_name%.*}"
    
    # Output prefix for single-page PDFs
    output_prefix="$dir_name/${file_name}_page"
    
    # Get the total number of pages in the PDF
    total_pages=$(gs -q -dNODISPLAY -c "($temp_file) (r) file runpdfbegin pdfpagecount = quit")
    
    # Determine the width of the page number field based on the total number of pages
    page_num_width=${#total_pages}
    
    # Loop through each page and extract it as a single-page PDF
    for ((page=1; page<=total_pages; page++)); do
        # Format the page number with leading zeros
        formatted_page_num=$(printf "%0${page_num_width}d" $page)
        output_file="${output_prefix}_${formatted_page_num}.pdf"
        gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=$page -dLastPage=$page -sOutputFile="$output_file" "$temp_file"
    done

    # Delete the temporary file
    rm "$temp_file"
done

echo "PDF files have been split into single pages"

