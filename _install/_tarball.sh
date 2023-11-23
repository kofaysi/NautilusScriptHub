#!/bin/bash

# Check if a file path is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 path/to/app-version.tar.bz2"
    exit 1
fi

TARBALL="$1"
APP_NAME=$(basename "$TARBALL" | cut -d '-' -f 1 | cut -d '.' -f 1)

# Check if the provided file exists
if [ ! -f "$TARBALL" ]; then
    echo "Error: File '$TARBALL' not found."
    exit 1
fi

# Uninstall Firefox
#apt-get remove --purge firefox

rm -rf /opt/$APP_NAME

# Extract the new version of the application
tar xjf "$TARBALL" -C /opt

# Update the symbolic link
ln -sf /opt/$APP_NAME/$APP_NAME /usr/bin/$APP_NAME

echo "$APP_NAME has been updated successfully."
notify-send "$0" "$APP_NAME has been updated successfully."
