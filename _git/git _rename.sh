#!/bin/bash

# Author: https://github.com/kofaysi/
# Description: Script to git mv a renamed file correctly
# Changelog:
# - [2025-02-08]: Initial commit.

# Import common script functions if available
if [ -f ~/.local/share/nautilus/scripts/script_utils.sh ]; then
    source ~/.local/share/nautilus/scripts/script_utils.sh
else
    echo "Error: script_utils.sh not found. Exiting."
    exit 1
fi

# Get the selected file (Nautilus passes file path as an argument)
FILE_PATH="$1"
DIR_PATH=$(dirname "$FILE_PATH")
OLD_NAME=$(basename "$FILE_PATH")

# Use Zenity to ask for the new file name, prefilled with the old name
NEW_NAME=$(zenity --entry --title="Rename File" --text="Enter new name:" --entry-text="$OLD_NAME")

# Check if user canceled or entered an empty name
if [ -z "$NEW_NAME" ]; then
    output_message "error" "Rename canceled or empty name provided."
    exit 1
fi

# Avoid renaming to the same name
if [ "$OLD_NAME" == "$NEW_NAME" ]; then
    output_message "error" "No changes made. Filename remains the same."
    exit 0
fi

# Rename the file
git mv "$FILE_PATH" "$DIR_PATH/$NEW_NAME" 2>/dev/null

# Check if rename was successful
if [ $? -eq 0 ]; then
    output_message "info" "File renamed successfully to: $NEW_NAME"
else
    output_message "error" "Error renaming file."
    exit 1
fi

