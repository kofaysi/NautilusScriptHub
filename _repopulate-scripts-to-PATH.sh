#!/bin/bash

# Adds Nautilus script directories to PATH if not already included.
# Author: https://github.com/kofaysi/
# Changelog:
# - [2024-05-09]: Initial version
# - [2025-01-25]: Added header
# - [2025-02-10]: Corrected $PATH export

for dir in ~/.local/share/nautilus/scripts/*; do
    if [[ -d "$dir" && ":$PATH:" != *":$dir:"* ]]; then
        export PATH="$PATH:$dir"
    fi
done

# Display the updated PATH
echo "Updated PATH: $PATH"
