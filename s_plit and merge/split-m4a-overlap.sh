#!/bin/bash

# Nautilus passes selected file as first argument
input_file="$1"

# Dependencies
command -v ffmpeg >/dev/null 2>&1 || { zenity --error --text="ffmpeg not found"; exit 1; }
command -v ffprobe >/dev/null 2>&1 || { zenity --error --text="ffprobe not found"; exit 1; }

# Settings
chunk_length=1800  # 30 minutes in seconds
overlap=60         # 1 minute overlap
step=$((chunk_length - overlap))

# Parse path
input_dir=$(dirname "$input_file")
input_base=$(basename "$input_file")
input_name="${input_base%.*}"
input_ext="${input_base##*.}"
output_prefix="${input_dir}/${input_name}-part"

# Get duration in seconds
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file")
duration=${duration%.*}  # truncate to integer seconds

# Loop
start=0
index=1

while [ "$start" -lt "$duration" ]; do
    end=$((start + chunk_length))
    [ "$end" -gt "$duration" ] && end="$duration"

    start_hms=$(printf '%02d:%02d:%02d' $((start/3600)) $((start%3600/60)) $((start%60)))
    end_hms=$(printf '%02d:%02d:%02d' $((end/3600)) $((end%3600/60)) $((end%60)))
    output_file="${output_prefix}${index}.m4a"

    echo "Extracting $start_hms to $end_hms -> $output_file"
    ffmpeg -y -i "$input_file" -ss "$start_hms" -to "$end_hms" -c copy "$output_file"

    start=$((start + step))
    index=$((index + 1))
done

zenity --info --text="All chunks created successfully."

