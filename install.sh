#!/bin/bash

path='/usr/local/bin'

if [ -d "$path" ]; then
    cp 'ascii.sh' "$path/ascii"
    cp 'distribution.sh' "$path/distribution"
    cp 'logfilter.sh' "$path/logfilter"
    cp 'pull.sh' "$path/pull"
    cp 'unwindows.sh' "$path/unwindows"
    cp 'wosut.sh' "$path/wosut"
else
    echo "Error: $path is not a directory"
fi
