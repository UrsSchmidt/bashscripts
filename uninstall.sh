#!/bin/bash

path='/usr/local/bin'

if [ ! -d "$path" ]; then
    echo "Error: $path is not a directory"
fi

if [ -f "$path/ascii" ]; then
    rm "$path/ascii"
fi

if [ -f "$path/logfilter" ]; then
    rm "$path/logfilter"
fi

if [ -f "$path/pull" ]; then
    rm "$path/pull"
fi

if [ -f "$path/unwindows" ]; then
    rm "$path/unwindows"
fi

if [ -f "$path/wosut" ]; then
    rm "$path/wosut"
fi
