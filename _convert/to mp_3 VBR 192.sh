#!/usr/bin/env bash
#
# Nautilus script: Convert selected .mp4/.mkv/.mov/.m4a files → .mp3 (VBR≈192 kbps).
# Skips non‐files, unsupported extensions, and already‐converted targets.

IFS=$'\n'  # handle spaces/newlines in filenames
SUPPORTED=("mp4" "mkv" "mov" "m4a")

convert_file() {
  local in="$1"
  local out="${in%.*}.mp3"

  if [[ -f "$out" ]]; then
    echo "Skipping exists: $out"
    return
  fi

  echo "Converting: $in → $out"
  if ffmpeg -hide_banner -nostats -v error \
            -i "$in" \
            -codec:a libmp3lame -qscale:a 2 \
            -map_metadata 0 \
            "$out"; then
    echo " → done"
  else
    echo " → ERROR, skipping"
    [[ -f "$out" ]] && rm -f "$out"
  fi
}

main() {
  for f in "$@"; do
    [ -f "$f" ] || { echo "Skipping non‐file: $f"; continue; }
    ext="${f##*.}"
    lc_ext=$(printf '%s' "$ext" | tr '[:upper:]' '[:lower:]')

    case "$lc_ext" in
      mp4|mkv|mov|m4a)
        convert_file "$f"
        ;;
      *)
        echo "Skipping unsupported: $f"
        ;;
    esac
  done
  zenity --info --title="Convert→MP3" --text="Done."
}

main "$@"

