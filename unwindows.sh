#!/bin/bash

# unwindows -- Updates file permissions.
# Use this script on files copied from FAT/NTFS USB flash drives.
#
# @author Urs Schmidt
#
# 2018-07-13 Make the source directory a parameter
# 2017-09-11 Now ignoring directories starting in a dot
#            Now ignoring files not containing a dot
# 2017-08-19 Initial version

source='.'
if [[ "$1" != '' ]]; then
    source="$1"
fi

if [[ -d "$source" ]]; then

    # all files and directories
    find "$source"                                       -not -path "*/.*/*" -exec chmod -c o-w {} \;

    # all files named *.* and not *.sh
    find "$source" -type f -name "*.*" -not -name "*.sh" -not -path "*/.*/*" -exec chmod -c a-x {} \;

    # all files named *.sh
    find "$source" -type f                  -name "*.sh" -not -path "*/.*/*" -exec chmod -c a+x {} \;

else
    echo "Error: $source is not a directory"
fi
