#!/usr/bin/env bash
# Nautilus script: Convert selected .m4a files to FLAC 16 kHz mono

set -u

# Check deps
if ! command -v ffmpeg >/dev/null 2>&1; then
  zenity --error --text="ffmpeg not found"; exit 1
fi

# Collect selected files (args or Nautilus env var)
declare -a files=()
if [ "$#" -gt 0 ]; then
  files=("$@")
else
  while IFS= read -r p; do
    [ -n "${p:-}" ] && files+=("$p")
  done <<< "${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS:-}"
fi

[ "${#files[@]}" -gt 0 ] || { zenity --error --text="No files selected."; exit 1; }

ok=0; fail=0
for inpath in "${files[@]}"; do
  [ -f "$inpath" ] || { ((fail++)); continue; }

  # accept only .m4a (case-insensitive)
  shopt -s nocasematch
  if [[ "$inpath" != *.m4a ]]; then
    shopt -u nocasematch
    continue
  fi
  shopt -u nocasematch

  outpath="${inpath%.*}.flac"

  # Convert: 16 kHz, mono, FLAC, keep tags if possible, don't overwrite
  if ffmpeg -hide_banner -loglevel error -n \
      -i "$inpath" -ar 16000 -ac 1 -c:a flac -compression_level 12 \
      -map_metadata 0 "$outpath"; then
    ((ok++))
  else
    ((fail++))
  fi
done

if command -v notify-send >/dev/null 2>&1; then
  notify-send "FLAC conversion" "Done: $ok  Failed: $fail"
fi

exit 0

