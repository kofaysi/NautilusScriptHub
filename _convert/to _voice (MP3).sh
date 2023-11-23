#!/bin/bash

# If no patterns are provided, set a default pattern of "*"
if [ $# -eq 0 ]; then
    set -- "*"
fi

# Loop over all patterns provided as arguments
for pattern; do
    for file in "$pattern"; do
        echo "Processing $file"
        lame --preset voice --noreplaygain "$file" temp.mp3
        mv -f temp.mp3 "$file"
    done
done

