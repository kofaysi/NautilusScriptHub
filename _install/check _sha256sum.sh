#!/bin/bash

# Ensure Zenity is installed for popup dialogs
if ! command -v zenity &> /dev/null; then
    zenity --error --text="Zenity is required but not installed. Please install it and try again."
    exit 1
fi

# Ensure a file was passed to the script
if [ -z "$1" ]; then
    zenity --error --text="No file selected. Please select a .sha256 file to verify."
    exit 1
fi

# The .sha256 file
SHA256_FILE="$1"

# Read the file for the checksum and target file
CHECKSUM="$(cut -d' ' -f1 "$SHA256_FILE")"
FILENAME="$(cut -d' ' -f3 "$SHA256_FILE" | sed 's/\r//')"

# Ensure the target file exists
if [ ! -f "$FILENAME" ]; then
    zenity --error --text="File '$FILENAME' referenced in '$SHA256_FILE' does not exist."
    exit 1
fi

# Verify the checksum
CALCULATED_CHECKSUM=$(sha256sum "$FILENAME" | cut -d' ' -f1)

if [ "$CALCULATED_CHECKSUM" == "$CHECKSUM" ]; then
    zenity --info --text="File '$FILENAME' passed the SHA256 verification."
else
    zenity --error --text="File '$FILENAME' failed the SHA256 verification.\nExpected: $CHECKSUM\nFound: $CALCULATED_CHECKSUM"
fi

