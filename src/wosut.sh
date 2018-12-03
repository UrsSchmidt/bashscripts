#!/bin/bash

# wosut -- Which operating system used this?
#
# @author Urs Schmidt

source='.'
if [[ "$1" != '' ]]; then
    source="$1"
fi

function handledir {
    dir="$1"
    for file in "$dir/"*; do
        name=$(basename "$file")
        namelc="${name,,}"
        if [[ "$name" == 'customized-capability.xml' \
           || "$name" == 'default-capability.xml' \
           || "$name" == 'LOST.DIR' ]]; then
            android=true
        elif [[ "$name" == '.DS_Store' || "$name" == '._.DS_Store' \
             || "$name" == '__MACOSX' \
             || "$name" == '.Spotlight-V100' \
             || "$name" == '.TemporaryItems' || "$name" == '._.TemporaryItems' \
             || "$name" == '.Trashes' || "$name" == '._.Trashes' \
             || "$name" == '.fseventsd' ]]; then
            macintosh=true
        elif [[ "$name" == '.Trash-'* \
             || "$name" == 'lost+found' ]]; then
            ubuntu=true
        elif [[ "$namelc" == 'autorun.inf' \
             || "$namelc" == 'desktop.ini' \
             || "$namelc" == '$recycle.bin' \
             || "$namelc" == 'system volume information' \
             || "$namelc" == 'thumbs.db' ]]; then
            windows=true
        fi
        if [[ -d "$file" ]]; then
            handledir "$file"
        fi
    done
}

if [[ -d "$source" ]]; then
    android=false
    macintosh=false
    ubuntu=false
    windows=false
    shopt -s dotglob
    handledir "$source"
    shopt -u dotglob
    if [ "$android"   != false ]; then echo "ANDROID";   fi
    if [ "$macintosh" != false ]; then echo "MACINTOSH"; fi
    if [ "$ubuntu"    != false ]; then echo "UBUNTU";    fi
    if [ "$windows"   != false ]; then echo "WINDOWS";   fi
else
    echo "Error: $source is not a directory"
fi
