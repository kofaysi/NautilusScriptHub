#!/bin/bash
source ~/.local/share/nautilus/scripts/script_utils.sh

for item in "$@"; do
    check_item_existence "$item" || continue
    datetime=$(get_formatted_timestamp "$item")
    rename_item "$item" "${datetime} $item"
done


