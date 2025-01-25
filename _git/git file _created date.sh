#!/bin/bash

# Ouput git creation date to a file
# Author: https://github.com/kofaysi/
# Description: This script retrieves the Git creation date of a selected file.
# Changelog:
# - [2025-01-25]: Initial release.
# 	- Added file name quoting and check for Git repository involvement.
# 	- Fixed the condition for checking if a file is committed in Git.
# 	- Improved terminal and zenity output handling with better formatting.
# 	- Refactored output handling into a reusable function.

# Function to handle output
output_message() {
  local title="$1"
  local text="$2"
  if [[ -t 1 ]]; then
    echo "$title: $text"
  else
    zenity --error --text="$text" --title="$title"
  fi
}

# Get the selected file from Nautilus
file="$1"

# Check if the file exists
if [[ ! -f "$file" ]]; then
  output_message "Error" "The selected file does not exist."
  exit 1
fi

# Check if the file is part of a Git repository
git_root=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ $? -ne 0 ]]; then
  output_message "Error" "The selected file is not in a Git repository."
  exit 1
fi

# Check if the file has been committed to Git
if ! git ls-files --error-unmatch "$file" > /dev/null 2>&1; then
  output_message "Error" "The selected file has never been committed to Git."
  exit 1
fi

# Run the Git command to get the file's creation date
git_creation_date=$(git log --follow --format=%ad --date=default "$file" | tail -1)

# Output the Git creation date
if [[ -t 1 ]]; then
  echo "Git creation date of '$file':"
  echo "$git_creation_date"
else
  zenity --info --text="Git creation date of '$file':\n\n$git_creation_date" --title="Git Creation Date"
fi
