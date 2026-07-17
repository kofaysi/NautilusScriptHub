#!/bin/bash
# Nautilus script: extract MP3 from selected MP4 files and normalize volume

# Dependencies: ffmpeg, mp3gain
# Install: sudo apt install ffmpeg mp3gain

for f in "$@"; do
    # skip if not mp4
    [[ "${f,,}" == *.mp4 ]] || continue

    base="${f%.*}"
    mp3="${base}.mp3"

    # extract audio to mp3 (re-encode for compatibility)
    ffmpeg -i "$f" -y -q:a 0 -map a "$mp3"

    # normalize mp3 volume, track-based, prevent clipping, keep undo
    mp3gain -r -k -c "$mp3"
done

