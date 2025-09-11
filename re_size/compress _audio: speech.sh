#!/bin/bash
# Nautilus script to compress audio files for speech

had_errors=false

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
		if ! mv "$file" "$original_file"; then
        had_errors=true
				continue
		fi

    # Convert to low bitrate mono MP3 (speech-optimized)
    ffmpeg -i "$original_file" -ac 1 -ar 22050 -b:a 32k "$file"
    # ffmpeg -i "$original_file" -ac 1 -ar 16000 -b:a 16k "$file"
		# ffmpeg -i "$original_file" -ac 1 -ar 8000 -b:a 12k "$file"
done

# Single final notification
if $had_errors; then
    notify-send "⚠️ Some files were skipped" "Audio compression finished with errors."
else
    notify-send "✅ Compression done" "All files processed successfully."
fi

