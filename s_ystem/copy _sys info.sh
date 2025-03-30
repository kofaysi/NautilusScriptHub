#!/bin/bash

# Check if inxi is installed
if ! command -v inxi &> /dev/null
then
    notify-send "Error" "inxi could not be found, please install it first."
    exit 1
fi

# Check if xclip is installed
if ! command -v xclip &> /dev/null
then
    notify-send "Error" "xclip could not be found, please install it first."
    exit 1
fi

# Fetch system information using inxi and copy it to the clipboard
inxi --tty -b | xclip -selection clipboard

# Notification to the user
notify-send "Success" "System information copied to clipboard."

