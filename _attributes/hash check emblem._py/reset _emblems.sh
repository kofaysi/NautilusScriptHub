#!/bin/bash

# Date: 2024-12-28
# Author: https://github.com/kofaysi
# Description: This Nautilus script identifies files with specific extended attributes (e.g., `metadata::emblems`)
# and provides an option to reset those attributes for selected files or directories, with optional recursive processing.

# Set GDK_BACKEND to x11 to ensure compatibility
export GDK_BACKEND=x11

# Extended attribute key
XATTR_KEY="metadata::emblems"
# Flag for recursive processing
RECURSIVE=false

# Check if recursive flag is passed
for arg in "$@"; do
    if [[ "$arg" == "-r" || "$arg" == "--recursive" ]]; then
        RECURSIVE=true
        break
    fi
done

# Function to find files with the attribute
find_files_with_xattr() {
    local dir="$1"
    local recursive="$2"
    if [[ "$recursive" == true ]]; then
        find "$dir" -type f
    else
        find "$dir" -maxdepth 1 -type f
    fi | while read -r file; do
        if gio info "$file" | grep -q "$XATTR_KEY"; then
            echo "$file"
        fi
    done
}

# Function to reset extended attributes for files
reset_xattr() {
    local dir="$1"
    local recursive="$2"
    if [[ "$recursive" == true ]]; then
        find "$dir" -type f
    else
        find "$dir" -maxdepth 1 -type f
    fi | while read -r file; do
        if gio info "$file" | grep -q "$XATTR_KEY"; then
            gio set --type=unset "$file" "$XATTR_KEY" 2>/dev/null || echo "Failed to remove attribute '$XATTR_KEY' from: $file"
        fi
    done
}

# Main execution
if [[ -z "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" ]]; then
    zenity --error --text="No files or directories were selected."
    exit 1
fi

# Initialize an empty string for files with attributes
FILES_WITH_XATTR=""

while IFS= read -r path; do
    if [[ -f "$path" ]]; then
        # Process files directly
        if gio info "$path" | grep -q "$XATTR_KEY"; then
            FILES_WITH_XATTR+="$path\n"
        fi
    elif [[ -d "$path" && "$RECURSIVE" == true ]]; then
        # Process files within directories if recursive flag is set
        while IFS= read -r file; do
            FILES_WITH_XATTR+="$file\n"
        done < <(find_files_with_xattr "$path" true)
    fi
done <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"

# Confirm and reset attributes
if [[ -n "$FILES_WITH_XATTR" ]]; then
    zenity --question --text="The following files have the '$XATTR_KEY' attribute:\n$FILES_WITH_XATTR\n\nDo you want to reset the extended attributes for these files?"
    if [[ $? -eq 0 ]]; then
        while IFS= read -r path; do
            if [[ -f "$path" ]]; then
                # Reset attribute for individual files
                gio set --type=unset "$path" "$XATTR_KEY" 2>/dev/null || echo "Failed to remove attribute '$XATTR_KEY' from: $path"
            elif [[ -d "$path" && "$RECURSIVE" == true ]]; then
                # Reset attributes in directories recursively
                reset_xattr "$path" true
            fi
        done <<< "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"
        zenity --info --text="All '$XATTR_KEY' attributes have been reset."
    else
        zenity --info --text="Operation canceled. No attributes were reset."
    fi
else
    zenity --info --text="No files with the '$XATTR_KEY' attribute were found."
fi
