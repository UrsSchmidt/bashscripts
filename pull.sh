#!/bin/bash

# pull -- Recursively updates git and svn repositories.
#
# @author Urs Schmidt

source='.'
if [ "$1" != '' ]; then
    source="$1"
fi

function handledir {
    dir="$1"
    if [ -d "$dir/.git" ]; then
        echo "$(basename $dir)"
        git -C "$dir" pull
    elif [ -d "$dir/.svn" ]; then
        echo "$(basename $dir)"
        svn update "$dir"
    else
        for subdir in "$dir/"*; do
            if [ -d "$subdir" ]; then
                handledir "$subdir"
            fi
        done
    fi
}

if [ -d "$source" ]; then
    handledir "$source"
else
    echo "Error: $source is not a directory"
fi
