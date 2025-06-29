#!/bin/bash
# Nautilus script to compress audio files for speech

# Loop through selected files
for file in "$@"; do
    # Skip non-audio files (basic check)
    [[ "$file" =~ \.(mp3|MP3|wav|WAV|m4a|M4A)$ ]] || continue

    # Get paths and names
    dir_name=$(dirname "$file")
    base_name=$(basename "$file")
    extension="${base_name##*.}"
    file_name="${base_name%.*}"

    # Rename original
    original_file="$dir_name/${file_name}-original.${extension}"
    mv "$file" "$original_file"

    # Convert to low bitrate mono MP3 (speech-optimized)
    ffmpeg -i "$original_file" -ac 1 -ar 22050 -b:a 32k "$file"
done

notify-send "Audio compression complete"

