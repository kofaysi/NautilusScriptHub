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

for input_image in "$@"; do
  # Check if the input file exists
  if [ ! -f "$input_image" ]; then
    echo "Error: Input image file '$input_image' not found."
    continue
  fi

  output_pdf="${input_image%.*}.pdf"

  # Convert the image to PDF
  convert "$input_image"  "$output_pdf"

#

  echo "Image '$input_image' converted to PDF: $output_pdf"
done

