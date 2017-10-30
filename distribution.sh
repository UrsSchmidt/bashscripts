#!/bin/bash

# distribution -- Shows lines of code in a directory separated by file extension.
#
# @author Urs Schmidt

# modes: human, total
mode='human'
if [[ "$1" != '' ]]; then
    mode="$1"
fi

source='.'
if [[ "$2" != '' ]]; then
    source="$2"
fi

if [[ -d "$source" ]]; then
    declare -iA lines
    declare -i totallines

    while IFS= read -r path; do
        l=$(cat "$path" | wc -l)
        lines["${path##*.}"]+=l
        totallines+=l
    done < <(find "$source" -type f -name "*.*" -not -path "$0" \
    -not -path "*/.*/*" \
    -exec file {} + | awk -F: '/ASCII text/ || /UTF-8 Unicode text/ {print $1}')

    if [[ "$mode" == 'human' ]]; then
        if [[ ( "$totallines" > 0 ) ]]; then
            for i in ${!lines[@]}; do
                l="${lines[$i]}"
                printf "%-12s %10s %6s\n" "$i:" "$l" "($((l*100/totallines))%)"
            done | sort -k2nr
            printf "%s\n" "------------------------------"
            printf "%-12s %10s %6s\n" "total:" "$totallines" "(100%)"
        else
            printf "No non-binary files found\n"
        fi
    elif [[ "$mode" == 'total' ]]; then
        echo "$totallines"
    else
        echo "Error: $mode is not a mode"
    fi
else
    echo "Error: $source is not a directory"
fi
