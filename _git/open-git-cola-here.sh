#!/bin/bash

# Get the current directory or the selected file's directory
if [ -n "$1" ]; then
    DIR=$(dirname "$1")
else
    DIR=$(pwd)
fi

# Find the Git repository root
GIT_REPO=$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null)

# Check if it's a valid Git repository
if [ -z "$GIT_REPO" ]; then
    notify-send "Git Cola" "No Git repository found in the selected folder."
    exit 1
fi

# Run git-cola using Flatpak
flatpak run com.github.git_cola.git-cola --repo "$GIT_REPO" &

