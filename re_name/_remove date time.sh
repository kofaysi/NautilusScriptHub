#!/bin/bash
source ~/.local/share/nautilus/scripts/script_utils.sh

for item in "$@"; do
    check_item_existence "$item" || continue
    rename_item "$item" "${item#????-??-?? ???? }"
done
