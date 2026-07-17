#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: $0 [-s seconds_step] FILE... | DIRECTORY

Sets files' access times (atime) so alphabetical order matches access-time order.
If a directory is provided, all regular files in it (non-recursive) are processed.

-s step    seconds difference between adjacent files (default 1)
EOF
}

step=1
while getopts ":s:h" opt; do
  case $opt in
    s) step=$OPTARG ;;
    h) usage; exit 0 ;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1 ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage; exit 1 ;;
  esac
done
shift $((OPTIND-1))

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

declare -a files
for arg in "$@"; do
  if [ -d "$arg" ]; then
    while IFS= read -r -d '' f; do
      files+=("$f")
    done < <(find "$arg" -maxdepth 1 -type f -print0)
  elif [ -f "$arg" ]; then
    files+=("$arg")
  else
    echo "Warning: '$arg' not found or not a regular file/dir" >&2
  fi
done

if [ ${#files[@]} -eq 0 ]; then
  echo "No files to process." >&2
  exit 1
fi

# use current time as newest atime
max=$(date +%s)

# sort alphabetically
mapfile -t sorted < <(printf '%s\0' "${files[@]}" | sort -z | tr '\0' '\n')
n=${#sorted[@]}

echo "Processing $n files with step=${step}s; newest atime=${max}."

for i in "${!sorted[@]}"; do
  idx=$i
  file=${sorted[$idx]}
  # compute new time so that last (alphabetically) gets max
  offset=$(( n - idx - 1 ))
  newt=$(( max - offset * step ))
  if [ $newt -lt 0 ]; then
    newt=0
  fi
  # set atime while preserving mtime using python to avoid date parsing differences
  python3 - <<PY "$file" "$newt"
import os,sys
path=sys.argv[1]
atime=int(sys.argv[2])
st=os.stat(path)
mtime=int(st.st_mtime)
os.utime(path, (atime, mtime))
print(path, 'atime->', atime, 'mtime preserved->', mtime)
PY
done

echo "Done. Files are now ordered by atime matching alphabetical order."
