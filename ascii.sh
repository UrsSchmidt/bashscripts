#!/bin/bash

for i in {32..127}; do
    printf '\x'$(printf '%x' "$i")
    if (( i % 16 == 15 )); then echo ''; fi
done
