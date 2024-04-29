#!/bin/bash

# Check if ip is installed
if ! command -v ip &> /dev/null
then
    notify-send "Error" "ip command could not be found, please ensure your system has net-tools or iproute2 installed."
    exit 1
fi

# Check if xclip is installed
if ! command -v xclip &> /dev/null
then
    notify-send "Error" "xclip could not be found, please install it first."
    exit 1
fi

# Fetch network information and copy to the clipboard
ip addr show | xclip -selection clipboard

# Notification to the user
notify-send "Success" "Network information copied to clipboard."

