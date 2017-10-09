#!/bin/bash

if [ -d '/usr/local/bin/' ]; then
    cp 'logfilter.sh' '/usr/local/bin/logfilter'
    cp 'pull.sh' '/usr/local/bin/pull'
    cp 'unwindows.sh' '/usr/local/bin/unwindows'
    cp 'wosut.sh' '/usr/local/bin/wosut'
fi
