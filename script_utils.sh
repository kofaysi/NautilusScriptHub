#!/bin/bash

# Script to collect common script functions
# Author: https://github.com/kofaysi/
# Description: This script collects the common script functions. The file is imported in other Nautilus bash scripts.
# Changelog:
# - [2025-01-25]: Initial version

# Function to handle output
output_message() {
  local title="$1"
  local text="$2"
  if [[ -t 1 ]]; then
    echo "$title: $text"
  else
  	case "$title" in
			*error*|*Error*|*ERROR*)
			  dialog_type="--error"
			  ;;
			*info*|*Info*|*INFO*)
			  dialog_type="--info"
			  ;;
			*notification*|*Notification*|*NOTIFICATION*)
			  dialog_type="--notification"
			  ;;
			*warning*|*Warning*|*WARNING*)
			  dialog_type="--warning"
			  ;;
			*)
			  dialog_type="--info" # Default to info dialog
		  ;;
		esac

		# Display the yad dialog
    zenity $dialog_type --text="$text" --title="$title"
  fi
}

# Function to check the number of input arguments
check_input_count() {
    local expected_count=$1
    local comparison=${2:-"-eq"}
    shift 2
    local actual_count=$#
    
    if ! [ "$actual_count" $comparison "$expected_count" ]; then
        output_message "Error" "Expected $comparison $expected_count arguments, but got $actual_count. Please provide the correct number of inputs."
        exit 1
    fi
}

#!/bin/bash

# Function to check if an item exists
check_item_existence() {
    local item="$1"
    if [[ -e "$item" ]]; then
        return 0  # Item exists
    else
        echo "File or directory not found: $item"
        return 1  # Item does not exist
    fi
}

# Function to extract creation timestamp and format it
get_formatted_timestamp() {
    local item="$1"
    local timestamp=$(stat -c %y "$item")
    echo $(date -d "$timestamp" +"%Y-%m-%d %H%M")
}

# Function to get the current date and time
get_current_datetime() {
    echo $(date +"%Y-%m-%d %H%M")
}

# Function to rename an item (file or directory)
rename_item() {
    local old_name="$1"
    local new_name="$2"
    mv "$old_name" "$new_name"
    echo "Renamed: $old_name -> $new_name"
}
