#!/bin/bash

# Check if argument is empty
if [ -z "$1" ]
then
  echo "No argument supplied"
  echo "Usage: ./copy_to_clipboard.sh [path]"
  exit 1
fi

# Get the absolute path
path=$(readlink -f "$1")

# Copy to clipboard
echo -n $path | xclip -selection clipboard
echo "Path $path copied to clipboard"
/home/milan/.local/share/nautilus/scripts/_attributes/path.sh
