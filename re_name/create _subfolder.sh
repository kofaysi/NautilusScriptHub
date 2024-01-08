#!/bin/bash

# Ask the user for the subfolder name
SUBFOLDER_NAME=$(zenity --entry --title="Enter Subfolder Name" --text="Please enter the name of the subfolder:")

# Check if the user actually entered something
if [ -z "$SUBFOLDER_NAME" ]; then
    zenity --error --text="No subfolder name was entered. Exiting script."
    exit 1
fi

# Loop through the passed arguments (selected folders) and create the subfolder
for dir in "$@"; do
    if [ -d "$dir" ]; then
        mkdir -p "$dir/$SUBFOLDER_NAME"
    fi
done

