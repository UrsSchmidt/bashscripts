#!/bin/bash

path='/usr/local/bin'

if [ -d "$path" ]; then
    for f in 'src/'*.sh; do
        cp "$f" "$path/$(basename $f .sh)"
    done
else
    echo "Error: $path is not a directory"
fi
