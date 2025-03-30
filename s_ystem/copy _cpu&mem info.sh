#!/bin/bash

# Check if top is installed
if ! command -v top &> /dev/null
then
    notify-send "Error" "top command could not be found, please install procps or a similar package."
    exit 1
fi

# Check if xclip is installed
if ! command -v xclip &> /dev/null
then
    notify-send "Error" "xclip could not be found, please install it first."
    exit 1
fi

# Fetch CPU and memory usage information and copy to the clipboard
top --tty -b -n 1 | head -5 | xclip -selection clipboard

# Notification to the user
notify-send "Success" "CPU and memory usage information copied to clipboard."

