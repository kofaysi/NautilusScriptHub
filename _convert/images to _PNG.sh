#!/bin/bash

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <image1> [image2 ...]"
  exit 1
fi

if ! command -v convert >/dev/null 2>&1; then
  echo "Error: ImageMagick 'convert' not found."
  exit 1
fi

for input in "$@"; do
  if [ ! -f "$input" ]; then
    echo "Skipping missing file: $input"
    continue
  fi

  dir=$(dirname "$input")
  name=$(basename "$input")
  base="${name%.*}"
  output="$dir/${base}.png"

  echo "Converting: $input -> $output"

  # First try ImageMagick directly
  if convert "$input" "$output" 2>/dev/null; then
    echo "OK: $output"
    continue
  fi

  # Fallback for WEBP if ImageMagick lacks WEBP support
  ext="${input##*.}"
  ext="${ext,,}"

  if [ "$ext" = "webp" ]; then
    if command -v dwebp >/dev/null 2>&1; then
      dwebp "$input" -o "$output"
    else
      echo "Error: WEBP conversion failed. Install support:"
      echo "sudo apt install webp imagemagick"
    fi
  else
    echo "Error: conversion failed: $input"
  fi
done