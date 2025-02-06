#!/bin/bash

# Set directory (current directory in this example)
DIR="."

# Get list of files in the directory and handle spaces properly
FILES=$(find "$DIR" -maxdepth 1 -type f | sed 's|./||')

# Prepare list values for Zenity checklist (preselected by default)
FILE_LIST=()
while IFS= read -r file; do
    if [ -n "$file" ]; then
        FILE_LIST+=("TRUE" "$file")  # Preselect all files
    fi
done <<< "$FILES"

# Check if any files were found
if [ ${#FILE_LIST[@]} -eq 0 ]; then
    zenity --error --text="No files found in the directory!"
    exit 1
fi

# Show Zenity checklist for file selection
SELECTED_FILES=$(zenity --list \
    --title="Select Files" \
    --text="Select files to save to selection.txt:" \
    --checklist \
    --column="Selection" --column="Filename" \
    "${FILE_LIST[@]}" \
    --separator="|" \
    --width=600 --height=400 \
    --multiple)

# Check if user canceled
if [ -z "$SELECTED_FILES" ]; then
    exit 1
fi

# Save selected files to a text file (preserving spaces)
echo "$SELECTED_FILES" | tr '|' '\n' > selection.txt
zenity --info --text="Selection saved to selection.txt"
