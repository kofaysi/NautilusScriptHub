#!/bin/bash

# Date: 2023-11-23
# Author: https://github.com/kofaysi
# Description: This script takes a file or directory path as an argument, resolves it to its absolute path, and copies the result to the clipboard.

# Check if argument is empty
if [ -z "$1" ]
then
  echo "No argument supplied"
  echo "Usage: ./path.sh [path]"
  exit 1
fi

# Get the absolute path
path=$(readlink -f "$1")

# Copy to clipboard
echo -n $path | xclip -selection clipboard
echo "Path $path copied to clipboard"

