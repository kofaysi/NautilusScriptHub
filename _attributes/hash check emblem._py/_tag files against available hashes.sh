#!/bin/bash

# Date: 2024-12-27
# Author: https://github.com/kofaysi
# Description: A Nautilus script to validate files against their corresponding hash files (e.g., .md5sum, .sha256sum). 
# If the hash matches, an emblem (e.g., 'emblem-shield') is applied to the file using the `gio` command. 
# Logs debug messages to a temporary file for troubleshooting.

# Configuration
EMBLEM_NAME="emblem-shield" # Display depends on $HOME/.icons/hicolor/*/emblems/emblem-shield.png
HASH_FILE_EXTENSIONS=("md5sum" "sha256sum")
DEBUG_FILE="/tmp/debug_output.txt"

# Log a message with a timestamp
log_debug_message() {
    local folder_path="$1"
    local message="$2"
    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $folder_path: $message" >> "$DEBUG_FILE"
}

# Check if an emblem is applied
is_emblem_applied() {
    local file_path="$1"
    local emblem_name="$2"
    log_debug_message "$(dirname "$file_path")" "Checking emblem '$emblem_name' for: $file_path"
    gio info -a metadata::emblems "$file_path" | grep -q "$emblem_name"
}

# Apply an emblem to a file
apply_emblem() {
    local file_path="$1"
    local emblem_name="$2"
    if is_emblem_applied "$file_path" "$emblem_name"; then
        log_debug_message "$(dirname "$file_path")" "Skipping emblem application for $file_path as it is already applied."
    else
        log_debug_message "$(dirname "$file_path")" "Applying emblem '$emblem_name' for: $file_path"
        gio set -t stringv "$file_path" metadata::emblems "$emblem_name"
    fi
}

# Validate a file against its hash file
validate_file_hash() {
    local file_path="$1"
    local hash_file="$2"
    local folder_path
    folder_path=$(dirname "$file_path")
    
    log_debug_message "$folder_path" "Validating $file_path against $hash_file"

    # Determine hash function
    local hash_func
    if [[ "$hash_file" == *.md5sum ]]; then
        hash_func="md5sum"
    elif [[ "$hash_file" == *.sha256sum ]]; then
        hash_func="sha256sum"
    else
        log_debug_message "$folder_path" "Unsupported hash type in $hash_file"
        return 1
    fi

    # Calculate and compare hash
    local calculated_hash
    calculated_hash=$(cat "$file_path" | "$hash_func" | awk '{print $1}')
    grep -q "$calculated_hash" "$hash_file"
}

# Main processing logic
process_file() {
    local file_path="$1"

    if [[ ! -f "$file_path" ]]; then
        log_debug_message "$file_path" "Ignored: Not a file"
        return
    fi

    for ext in "${HASH_FILE_EXTENSIONS[@]}"; do
        local hash_file="${file_path}.${ext}"
        if [[ -f "$hash_file" ]]; then
            if validate_file_hash "$file_path" "$hash_file"; then
                apply_emblem "$file_path" "$EMBLEM_NAME"
                return
            else
                log_debug_message "$(dirname "$file_path")" "Hash mismatch for $file_path"
            fi
        fi
    done

    log_debug_message "$(dirname "$file_path")" "No valid hash file found for $file_path"
}

# Iterate over files provided as arguments
for file in "$@"; do
    process_file "$file"
done

