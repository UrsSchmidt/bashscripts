#!/bin/bash

# unwindows -- Updates file permissions.
# Use this script on directories copied from FAT/NTFS USB flash drives.
#
# @author Urs Schmidt
#
# 2019-08-16 Added a+r,u+w,g+w for all files and directories
# 2018-08-29 Now handling .desktop files as well
#            Now case-insensitive
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
    find "$source" \
        -not -path '*/.*/*' -exec chmod -c 'a+r,u+w,g+w,o-w' {} \;

    # all files named *.* and not (*.desktop or *.sh)
    find "$source" \
        -type f \( -iname '*.*' -a -not \( -iname '*.desktop' -o -iname '*.sh' \) \) \
        -not -path '*/.*/*' -exec chmod -c 'a-x' {} \;

    # all files named *.desktop or *.sh
    find "$source" \
        -type f \( -iname '*.desktop' -o -iname '*.sh' \) \
        -not -path '*/.*/*' -exec chmod -c 'a+x' {} \;

else
    echo "Error: $source is not a directory"
fi
