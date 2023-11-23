#!/bin/bash

#zenity --info --text="Script started, processing $1"

# Function to convert to absolute path if necessary
get_absolute_path() {
    local path="$1"
    if [[ "$path" = /* ]]; then
        echo "$path"  # Path is already absolute
    else
        echo "$(pwd)/$path"  # Convert to absolute path
    fi
}

# Check if a file path is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path/to/app-version.tar.bz2"
    exit 1
fi

# Convert to absolute path
TARBALL="$(get_absolute_path "$1")"

#zenity --info --text="Executing _tarball.sh $TARBALL"
#notify-send "Title" "Your message here"

# Call the second script, passing the absolute tarball path
pkexec /home/milan/.local/share/nautilus/scripts/_install/_tarball.sh "$TARBALL"

