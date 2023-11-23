#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <input_image_file1> [<input_image_file2> ...]"
  exit 1
fi

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
  echo "Error: ImageMagick not found. Please install ImageMagick."
  exit 1
fi

# Define the A4 page dimensions in pixels with 300dpi density
page_width=2480  # 8.27 inches * 300 dpi
page_height=3508 # 11.69 inches * 300 dpi

for input_image in "$@"; do
  # Check if the input file exists
  if [ ! -f "$input_image" ]; then
    echo "Error: Input image file '$input_image' not found."
    continue
  fi

  output_pdf="${input_image%.*}.pdf"

  # Use convert to auto-fit the image to the PDF size and set print quality
  convert "$input_image" -resize "${page_width}x${page_height}" -density 300x300 -units pixelsperinch "$output_pdf"

  echo "Image '$input_image' converted to PDF with A4 format (300dpi), auto-fit, and print quality: $output_pdf"
done

