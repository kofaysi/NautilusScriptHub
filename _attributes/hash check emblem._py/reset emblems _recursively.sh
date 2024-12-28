#!/bin/bash

# Date: 2024-12-27
# Author: https://github.com/kofaysi
# Description: This script is a wrapper that calls the "reset _emblems.sh" script recursively with the `-r` (recursive) option. 
# Ensures compatibility with Nautilus and verifies the presence of the target script before execution.

# Set GDK_BACKEND to x11 to ensure compatibility
export GDK_BACKEND=x11

# Path to the reset_emblems.sh script
RESET_EMBLEMS_SCRIPT="$HOME/.local/share/nautilus/scripts/_attributes/reset _emblems.sh"

# Check if the script exists
if [[ ! -f "$RESET_EMBLEMS_SCRIPT" ]]; then
    echo "Error: The $RESET_EMBLEMS_SCRIPT script was not found."
    exit 1
fi

# Call the reset_emblems.sh script with the -r switch
bash "$RESET_EMBLEMS_SCRIPT" --recursive

# Exit with the same status as the called script
exit $?
