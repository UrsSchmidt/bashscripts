#!/bin/bash

# unwindows -- Updates file permissions.
# Use this script on files copied from FAT/NTFS USB flash drives.
#
# @author Urs Schmidt
#
# 2017-09-11 Now ignoring directories starting in a dot
#            Now ignoring files not containing a dot
# 2017-08-19 Initial version

# all files and directories
find .                                       -not -path "*/.*/*" -exec chmod -c o-w {} \;

# all files named *.* and not *.sh
find . -type f -name "*.*" -not -name "*.sh" -not -path "*/.*/*" -exec chmod -c a-x {} \;

# all files named *.sh
find . -type f                  -name "*.sh" -not -path "*/.*/*" -exec chmod -c a+x {} \;
