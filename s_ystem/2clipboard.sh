#!/bin/bash
# Universal clipboard helper script
# Author: https://github.com/kofaysi/
# Description: Redirects stdin to clipboard using xclip, xsel, or wl-copy
# Changelog:
# - [2025-02-10] Initial commit

if command -v xclip &> /dev/null; then
    xclip -selection clipboard
elif command -v wl-copy &> /dev/null; then
    wl-copy
elif command -v xsel &> /dev/null; then
    xsel --clipboard
else
    echo "Error: No clipboard tool found. Install xclip, wl-copy, or xsel." >&2
    exit 1
fi

