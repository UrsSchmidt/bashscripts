#!/bin/bash

# patchwork -- Automatically applies git patches to a directory.
#
# @author Urs Schmidt

if [[ "$#" -ne 2 && "$#" -ne 3 ]]
then
    echo 'Usage: patchwork <project> <patch> [<performCommit>]'
    exit 1
fi

rootProject="$1"
rootPatch="$2"
performCommit='true'
if [[ "$#" -eq 3 ]]
then
    performCommit="$3"
fi
verbose='true'

# https://stackoverflow.com/a/8574392
containsElement() {
    local e match="$1"
    shift
    for e; do [[ "$e" == "$match" ]] && return 0; done
    return 1
}

appliedPatches=()

applyPatch() {
    local project="${1%/}/"
    local patch="${2%/}/"
    local required="$3"

    if containsElement "$patch" "${appliedPatches[@]}"
    then
        if [[ "$verbose" == 'true' ]]; then echo "[DUP] $patch"; fi
    else
        if [[ "$verbose" == 'true' ]]; then echo "[BGN] $patch"; fi

        # default values
        active='true'
        requires=''
        title="$patch"

        local configFile="${patch}config.sh"
        if [[ -f "$configFile" ]]
        then
            . ./"$configFile"
        fi

        if [[ "$active" == 'true' ]]
        then
            IFS=';' read -r -a requiresArray <<< "$requires"
            for requiredPatch in "${requiresArray[@]}"
            do
                if [[ "$verbose" == 'true' ]]; then echo "[REQ] $patch requires $requiredPatch"; fi
                applyPatch "$project" "$requiredPatch" 'true'
            done

            local patchFile="${patch}patch.diff"
            if [[ -f "$patchFile" ]]
            then
                echo "[GIT] $patchFile"
                git -C "$project" apply "$(pwd)/$patchFile"
                if [[ "$performCommit" == 'true' ]]
                then
                    git -C "$project" add -A
                    git -C "$project" commit -m "$title" -q
                fi
            fi
            appliedPatches+=("$patch")

            for subPatch in "$patch"*
            do
                if [[ -d "$subPatch" && "$(basename $subPatch)" =~ ^[^_].* ]]
                then
                    applyPatch "$project" "$subPatch" 'false'
                fi
            done
        else
            if [[ "$verbose" == 'true' ]]; then echo "[SKP] $patch"; fi
            if [[ "$required" == 'true' ]]
            then
                echo "[ERR] REQUIRED PATCH $patch WAS SKIPPED!"
            fi
        fi

        if [[ "$verbose" == 'true' ]]; then echo "[END] $patch"; fi
    fi
}

applyPatch "$rootProject" "$rootPatch" 'false'
