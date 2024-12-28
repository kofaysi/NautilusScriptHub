#!/bin/bash

# Date: 2024-04-29
# Author: https://github.com/kofaysi
# Description: Bash script to compare two PDFs page by page and highlight differences using subtraction in ImageMagick

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 pdf1.pdf pdf2.pdf"
    exit 1
fi

pdf1="$1"
pdf2="$2"
output_dir="diff_output"

# Create a directory for output images
mkdir -p "$output_dir"

# Convert PDFs to images with ImageMagick, starting from page 0
convert_pdf_to_images() {
    local pdf_file="$1"
    local output_prefix="$2"
    convert -density 150 "$pdf_file" -quality 100 "${output_prefix}page_%04d.png"
    echo $(ls "${output_prefix}"page_*.png | wc -l)
}

# Convert each PDF to images
num_pages_pdf1=$(convert_pdf_to_images "$pdf1" "${output_dir}/pdf1_")
num_pages_pdf2=$(convert_pdf_to_images "$pdf2" "${output_dir}/pdf2_")

# Determine the smaller number of pages to avoid out-of-range errors
min_pages=$((num_pages_pdf1 < num_pages_pdf2 ? num_pages_pdf1 : num_pages_pdf2))

# Subtract and compare each page
for (( page=0; page<min_pages; page++ )); do
    page_formatted=$(printf "%04d" $page)
    img1="${output_dir}/pdf1_page_${page_formatted}.png"
    img2="${output_dir}/pdf2_page_${page_formatted}.png"
    diff_img="${output_dir}/diff_page_${page}.png"

    # Subtract the images to highlight differences
    convert "$img1" "$img2" -compose difference -composite -negate "$diff_img"

    echo "Generated difference image for page $page."
done

echo "Comparison complete. Difference images are in ${output_dir}/"

