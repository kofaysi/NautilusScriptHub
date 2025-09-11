#!/bin/bash
# Compress audio files to ultra-low-quality speech; results go to a " LQ" folder

had_errors=false

compress_file() {
    local input="$1"
    local output="$2"

    if [[ -f "$output" ]]; then
        echo "Skipping existing: $output"
        return
    fi

    ffmpeg -i "$input" -ac 1 -ar 22050 -b:a 32k "$output" -y < /dev/null || had_errors=true
}

for target in "$@"; do
    if [[ -d "$target" ]]; then
        # Directory: compress all audio files inside
        src_dir="$(realpath "$target")"
        base_name="$(basename "$src_dir")"
        parent_dir="$(dirname "$src_dir")"
        dest_dir="$parent_dir/${base_name} LQ"

        mkdir -p "$dest_dir"

        find "$src_dir" -maxdepth 1 -type f \( -iname '*.mp3' -o -iname '*.wav' -o -iname '*.m4a' \) | while read -r file; do
            filename="$(basename "$file")"
            compress_file "$file" "$dest_dir/$filename"
        done

    elif [[ "$target" =~ \.(mp3|MP3|wav|WAV|m4a|M4A)$ ]]; then
        # Single file: create sibling "LQ" folder and process it
        dir_name="$(dirname "$(realpath "$target")")"
        base_name="$(basename "$target")"
        dest_dir="$dir_name/LQ"

        mkdir -p "$dest_dir"
        compress_file "$target" "$dest_dir/$base_name"
    fi
done

# Final single notification
if $had_errors; then
    notify-send "⚠️ Audio compression finished" "Some files failed to compress."
else
    notify-send "✅ Audio compression complete" "All files saved to LQ folders."
fi

