#!/bin/bash
source ~/.local/share/Nautilus/scripts/script_utils.sh

datetime=$(get_current_datetime)

for item in *; do
    check_item_existence "$item" || continue
    rename_item "$item" "${datetime} $item"
done
