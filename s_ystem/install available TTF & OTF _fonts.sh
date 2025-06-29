#!/usr/bin/env bash

# Enable nullglob so that *.ttf or *.otf won't stay as literal if no matches
shopt -s nullglob

# Collect TTF and OTF files in arrays
ttf_files=( *.ttf )
otf_files=( *.otf )

# If neither TTF nor OTF files are found, exit early
if [ ${#ttf_files[@]} -eq 0 ] && [ ${#otf_files[@]} -eq 0 ]; then
    # Optional: Show a desktop notification, if desired
    if command -v notify-send &>/dev/null; then
        notify-send "Install Fonts" "No TTF or OTF fonts found in the current directory."
    fi
    exit 0
fi

# Combine our copy + cache commands in a single pkexec call
pkexec /bin/bash -c "
    cp ./*.ttf /usr/share/fonts/truetype/ 2>/dev/null || true
    cp ./*.otf /usr/share/fonts/opentype/ 2>/dev/null || true
    fc-cache -f -v
"

# Optional: Show a desktop notification if notify-send exists
if command -v notify-send &>/dev/null; then
    notify-send "Install Fonts" "Fonts installed and cache rebuilt."
fi

