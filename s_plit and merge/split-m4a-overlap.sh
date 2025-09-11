#!/bin/bash
set -euo pipefail

# Nautilus passes selected file as first argument
: "${1:?No input file provided}"
input_file="$1"

# Dependencies
command -v ffmpeg  >/dev/null 2>&1 || { zenity --error --text="ffmpeg not found";  exit 1; }
command -v ffprobe >/dev/null 2>&1 || { zenity --error --text="ffprobe not found"; exit 1; }

# Settings
chunk_length=1800   # 30 minutes in seconds
overlap=60          # 1 minute overlap
step=$((chunk_length - overlap))  # 1740 seconds

# Parse path
input_dir=$(dirname "$input_file")
input_base=$(basename "$input_file")
input_name="${input_base%.*}"
output_prefix="${input_dir}/${input_name}-part"

# Duration in seconds (integer). Prefer audio stream duration, fallback to format.
duration=$(ffprobe -v error -select_streams a:0 -show_entries stream=duration -of default=nokey=1:noprint_wrappers=1 "$input_file" || true)
if [[ -z "${duration}" || "${duration}" == "N/A" ]]; then
  duration=$(ffprobe -v error -show_entries format=duration -of default=nokey=1:noprint_wrappers=1 "$input_file")
fi
duration=${duration%.*}
if ! [[ "$duration" =~ ^[0-9]+$ ]] || [ "$duration" -le 0 ]; then
  zenity --error --text="Cannot determine duration."
  exit 1
fi

# Helper: seconds -> HH:MM:SS
to_hms() {
  local s=$1
  printf '%02d:%02d:%02d' $((s/3600)) $(((s%3600)/60)) $((s%60))
}

# Loop
start=0
index=1
while [ "$start" -lt "$duration" ]; do
  remaining=$((duration - start))
  this_len=$(( remaining < chunk_length ? remaining : chunk_length ))

  start_hms=$(to_hms "$start")
  len_hms=$(to_hms "$this_len")
  output_file="${output_prefix}${index}.m4a"

  echo "Extracting start=${start_hms} len=${len_hms} -> ${output_file}"
  # Audio-only M4A with stream copy; maps first audio stream if present
  ffmpeg -hide_banner -loglevel error -y \
    -ss "$start_hms" -i "$input_file" -t "$len_hms" \
    -vn -map a:0? -c:a copy "$output_file" \
    || { zenity --error --text="ffmpeg failed at part ${index}"; exit 1; }

  start=$((start + step))
  index=$((index + 1))
done

zenity --info --text="All chunks created successfully."

