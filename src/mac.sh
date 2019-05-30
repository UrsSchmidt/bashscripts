#!/bin/bash

# mac -- music archive checker; Checks my music archive for inconsistencies.
#
# @author Urs Schmidt

src='.'
if [[ "$1" != '' ]]; then
    src="$1"
fi

cd "$src"

tmpfile=$(mktemp /tmp/mac.XXXXXX)

find . -type f \
    | grep -Ev '^\./.*/.*/folder\.jpg$' \
    | grep -Ev '^\./.*/.*/[0-9]+\.[0-9]+\. .*\.cue$' \
    | grep -Ev '^\./.*/.*/.*\.flac$' \
    | grep -Ev '^\./.*/.*/.*\.m4a$' \
    | grep -Ev '^\./.*/.*/.*\.mp3$' \
    | grep -Ev '^\./.*/.*/.*\.webm$' \
    | grep -Ev '^\./Stub.jpg$' \
    | sed 's/$/__This file path does not match any given pattern./' >> "$tmpfile"

find . -mindepth 2 -maxdepth 2 -type d '!' -exec sh -c 'ls -1 "{}" | grep -Eq "^.*\.(flac|m4a|mp3|webm)$"' ';' -print \
    | sed 's/$/__This directory does not contain any audio files./' >> "$tmpfile"

find . -mindepth 2 -maxdepth 2 -type d '!' -exec sh -c 'ls -1 "{}" | grep -Eq "^folder\.jpg$"' ';' -print \
    | sed 's/$/__This directory does not contain any artwork./' >> "$tmpfile"

find . -type f -name 'folder.jpg' -exec identify -format "%d %wx%h\n" {} \; \
    | grep -Ev '^.* 600x600$' \
    | sed 's/ [[:digit:]]\+x[[:digit:]]\+$/__This artwork does not have the resolution 600x600./' >> "$tmpfile"

sort "$tmpfile" | sed 's/__/\n>>> /'
rm "$tmpfile"
