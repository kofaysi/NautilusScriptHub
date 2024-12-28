#!/bin/bash

# Date: 2024-10-15
# Author: https://github.com/kofaysi
# Description: This script updates the last modified timestamp of selected files in Nautilus to the current time.

# Loop through each selected file in Nautilus
for file in "$@"; do
    # Update the last modified date to the current time
    touch "$file"
done

# Notify the user of the update
notify-send "Timestamp Updated" "Last modified date has been updated for selected items."

