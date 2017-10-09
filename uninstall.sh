#!/bin/bash

if [ -f '/usr/local/bin/logfilter' ]; then
    rm '/usr/local/bin/logfilter'
fi

if [ -f '/usr/local/bin/pull' ]; then
    rm '/usr/local/bin/pull'
fi

if [ -f '/usr/local/bin/unwindows' ]; then
    rm '/usr/local/bin/unwindows'
fi

if [ -f '/usr/local/bin/wosut' ]; then
    rm '/usr/local/bin/wosut'
fi
