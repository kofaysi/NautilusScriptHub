#!/bin/bash

# Adds Nautilus script directories to PATH if not already included.
# Author: https://github.com/kofaysi/
# Changelog:
# - [2024-05-09]: Initial version
# - [2025-01-25]: Added header

for dir in ~/.local/share/nautilus/scripts/*; do
	[[ ":$PATH:" != *":$dir:"* ]] && PATH="$PATH:$dir"
done
