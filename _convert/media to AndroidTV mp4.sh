# Nautilus “Scripts” approach (right-click → Scripts → Convert for AndroidTV)
# Save this file as:
#   ~/.local/share/nautilus/scripts/Convert to AndroidTV (MP4 H.264 AAC)
# Then make executable:
#   chmod +x ~/.local/share/nautilus/scripts/Convert\ to\ AndroidTV\ \(MP4\ H.264\ AAC\)
#
# Dependencies:
#   sudo apt install ffmpeg libnotify-bin

#!/usr/bin/env bash
set -eu

# ---------- Settings (Android TV safe defaults) ----------
CRF="${CRF:-21}"                 # 18 higher quality/bigger; 23 smaller/lower quality
PRESET="${PRESET:-fast}"         # ultrafast..veryslow
AUDIO_BITRATE="${AUDIO_BITRATE:-160k}"
LEVEL="${LEVEL:-4.0}"            # conservative for older devices
PROFILE="${PROFILE:-high}"

# Output folder name (created next to each source file)
OUTDIR_NAME="${OUTDIR_NAME:-AndroidTV}"

# Extra: move moov atom to beginning for fast start
MOVFLAGS="+faststart"

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "AndroidTV conversion" "$1"
  else
    echo "$1"
  fi
}

# ---------- Input handling ----------
if [ "$#" -lt 1 ]; then
  notify "No files received. Select files in Nautilus and run the script again."
  exit 0
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  notify "ffmpeg not found. Install with: sudo apt install ffmpeg"
  exit 1
fi

# Nautilus passes selected files as arguments. Work per-file.
fail_count=0
ok_count=0

for inpath in "$@"; do
  # Nautilus may pass URIs in some setups; handle file:// just in case.
  if [[ "$inpath" == file://* ]]; then
    inpath="${inpath#file://}"
    inpath="${inpath//%20/ }"
  fi

  # Skip non-regular files
  if [ ! -f "$inpath" ]; then
    continue
  fi

  indir="$(dirname "$inpath")"
  base="$(basename "$inpath")"
  name="${base%.*}"

  outdir="${indir}/${OUTDIR_NAME}"
  mkdir -p "$outdir"

  outpath="${outdir}/${name}.mp4"

  # Avoid overwrite: if exists, add _001, _002...
  if [ -e "$outpath" ]; then
    i=1
    while : ; do
      outpath="${outdir}/${name}_$(printf '%03d' "$i").mp4"
      [ ! -e "$outpath" ] && break
      i=$((i+1))
    done
  fi

  echo "=== Converting ==="
  echo "IN : $inpath"
  echo "OUT: $outpath"
  echo

  # Transcode to AndroidTV-friendly MP4:
  # - H.264 (yuv420p) + AAC
  # - scale only if needed? (keeps original resolution)
  # - +faststart for smoother streaming
  if ffmpeg -hide_banner -y -i "$inpath" \
      -map 0:v:0? -map 0:a:0? \
      -c:v libx264 -preset "$PRESET" -crf "$CRF" \
      -profile:v "$PROFILE" -level "$LEVEL" -pix_fmt yuv420p \
      -c:a aac -b:a "$AUDIO_BITRATE" \
      -movflags "$MOVFLAGS" \
      "$outpath"; then
    ok_count=$((ok_count+1))
  else
    fail_count=$((fail_count+1))
    echo "FAILED: $inpath" >&2
  fi

  echo
done

notify "Done. Success: ${ok_count}, Failed: ${fail_count}. Output folder: ${OUTDIR_NAME}"
exit 0
