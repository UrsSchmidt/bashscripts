#!/bin/bash

path='/usr/local/bin'

if [ -d "$path" ]; then
    for f in 'src/'*.sh; do
        rm "$path/$(basename $f .sh)"
    done
else
    echo "Error: $path is not a directory"
fi
