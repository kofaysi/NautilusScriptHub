#!/bin/bash

# Check if df is installed
if ! command -v df &> /dev/null
then
    notify-send "Error" "df command could not be found, please ensure core utilities are installed."
    exit 1
fi

# Check if xclip is installed
if ! command -v xclip &> /dev/null
then
    notify-send "Error" "xclip could not be found, please install it first."
    exit 1
fi

# Fetch disk usage information and copy to the clipboard
df -h | xclip -selection clipboard

# Notification to the user
notify-send "Success" "Disk usage information copied to clipboard."

