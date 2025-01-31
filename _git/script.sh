#!/bin/bash

# Set directory (current directory in this example)
DIR="."

# Get list of files in the directory and handle spaces properly
FILES=$(ls -1 "$DIR")
echo $FILES

# Prepare list values for Zenity checklist (preselected by default)
FILE_LIST=()
while IFS= read -r file; do
    FILE_LIST+=("$file")  # Preselect all files
done <<< "$FILES"

# Show Zenity checklist for file selection
SELECTED_FILES=$(zenity --list \
    --title="Select Files" \
    --text="Select files to save to selection.txt:" \
    --checklist \
    --column="Select" --column="Filename" \
    "${FILE_LIST[@]}" \
    --separator="|" \
    --width=600 --height=400 \
    --multiple)

# Check if user canceled
if [ -z "$SELECTED_FILES" ]; then
    echo "No selection made. Exiting."
    exit 1
fi

# Save selected files to a text file (preserving spaces)
echo "$SELECTED_FILES" | tr '|' '\n' > selection.txt
echo "Selection saved to selection.txt"

# Display result
cat selection.txt

