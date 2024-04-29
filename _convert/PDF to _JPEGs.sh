#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <input_pdf_file1> [<input_pdf_file2> ...]"
  exit 1
fi

# Check if ImageMagick's convert command is installed
if ! command -v convert &> /dev/null; then
  echo "Error: ImageMagick not found. Please install ImageMagick."
  exit 1
fi

for input_pdf in "$@"; do
  # Check if the input file exists
  if [ ! -f "$input_pdf" ]; then
    echo "Error: Input PDF file '$input_pdf' not found."
    continue
  fi

  # Extract the filename without the extension
  base_name=$(basename "$input_pdf" .pdf)

  # Convert the PDF to high-quality JPEGs
  # -density sets the DPI (for quality)
  # -quality sets the compression quality (max is 100)
  # Adjusted the numbering to start from 1 instead of 0
  convert -strip -colorspace sRGB -density 300 "$input_pdf" -quality 100 "${base_name}_%04d.jpg"
  #convert -strip -colorspace sRGB "$input_pdf" "${base_name}_%04d.jpg"

  echo "PDF '$input_pdf' converted to high-quality JPEGs in the current directory."
done

