#!/bin/bash

# shrnd -- Show random; open a random image or video in either eye-of-gnome or vlc.
#
# @author Urs Schmidt

count=1
if [[ "$1" != '' ]]; then
    count="$1"
fi

find . -type f \( -iname '*.flv' -o -iname '*.gif' -o -iname '*.jpg' -o -iname '*.mp4' -o -iname '*.png' -o -iname '*.wmv' \) | shuf -n "$count" | while IFS= read -r file; do
    if [[ "$file" == *.gif || "$file" == *.jpg || "$file" == *.png ]]; then
        echo "Image: $file"
        eog --fullscreen "$file"
    elif [[ "$file" == *.flv || "$file" == *.mp4 || "$file" == *.wmv ]]; then
        echo "Video: $file"
        length=$(ffprobe -i "$file" -show_entries format=duration -v quiet -of csv="p=0")
        if [[ "$length" != '' ]]; then
            length=$(printf "%.0f\n" "$length")
            random=$(shuf -i 0-"$length" -n 1)
            vlc --no-loop --play-and-exit -q --start-time="$random" "$file" > /dev/null 2>&1
        else
            echo "Error: no length <$file>"
        fi
    else
        echo "Error: unknown extension <$file>"
    fi
done
