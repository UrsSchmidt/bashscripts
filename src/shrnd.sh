#!/bin/bash

# shrnd -- Show random; opens a random image or video file in either eye-of-gnome or vlc.
#
# @author Urs Schmidt

count=1
mode=-a # -a, -i, -v
src='.'
for arg in "$@"; do
    if [[ "$arg" =~ ^-[aiv]$ ]]; then
        mode="$arg"
    elif [[ "$arg" =~ ^[0-9]+$ ]]; then
        count="$arg"
    else
        src="$arg"
    fi
done

findargs=()
if [[ "$mode" == '-a' || "$mode" == '-i' ]]; then
    if [[ "${#findargs[@]}" -ne 0 ]]; then
        findargs+=(-o)
    fi
    findargs+=(-iname '*.bmp' -o -iname '*.gif' -o -iname '*.jpeg' -o -iname '*.jpg' -o -iname '*.png')
fi
if [[ "$mode" == '-a' || "$mode" == '-v' ]]; then
    if [[ "${#findargs[@]}" -ne 0 ]]; then
        findargs+=(-o)
    fi
    findargs+=(-iname '*.avi' -o -iname '*.flv' -o -iname '*.mp4' -o -iname '*.wmv')
fi

echo find "$src" -type f \( "${findargs[@]}" \)
find "$src" -type f \( "${findargs[@]}" \) | shuf -n "$count" | while IFS= read -r file; do
    if [[ "$file" =~ \.(bmp|gif|jpeg|jpg|png)$ ]]; then
        echo "Image: $file"
        eog --fullscreen "$file"
    elif [[ "$file" =~ \.(avi|flv|mp4|wmv)$ ]]; then
        echo "Video: $file"
        length=$(ffprobe -i "$file" -show_entries format=duration -v quiet -of csv="p=0")
        if [[ "$length" != '' ]]; then
            length=$(printf "%.0f\n" "$length")
            random=$(shuf -i 0-"$length" -n 1)
            vlc -f --no-loop --play-and-exit -q --start-time="$random" "$file"
        else
            echo "Error: no length <$file>"
        fi
    else
        echo "Error: unknown extension <$file>"
    fi
done
