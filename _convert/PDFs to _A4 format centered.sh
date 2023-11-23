#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <input_pdf_file1> [<input_pdf_file2> ...]"
  exit 1
fi

# Check if Ghostscript is installed
if ! command -v gs &> /dev/null; then
  echo "Error: Ghostscript not found. Please install Ghostscript."
  exit 1
fi

for input_pdf in "$@"; do
  # Check if the input file exists
  if [ ! -f "$input_pdf" ]; then
    echo "Error: Input PDF file '$input_pdf' not found."
    continue
  fi

  output_pdf="${input_pdf%.*}_formatted.pdf"

  # Use Ghostscript to format the PDF to A4 size, center content, and rotate between landscape and portrait
  gs -o "$output_pdf" -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dFIXEDMEDIA -dPDFFitPage -c "<</Orientation 3>> setpagedevice" -f "$input_pdf"

  echo "PDF '$input_pdf' formatted to A4 size, centered, and rotated: $output_pdf"
done

