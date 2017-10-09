#!/bin/bash

# logfilter -- shows an automatically filtered git log
#
# @author Urs Schmidt

source='.'
if [ "$1" != '' ]; then
    source="$1"
fi

regex1='(((even more)|(lots of)|more|some) )?((minor|small) )?(coding-style )?(changes|(fix(es)?))( in the documentation)?'
regex2='((adjust(ed)?)|(enhance(d)?)|(fix(ed)?)|(update(d)?)) (((some )?comment(s)?)|documentation|(readme(\.[a-z]+)?)|((some )?typos))'
regex3='((even )?more )?clean-up'
regex4='hot-fix(es)?'

regex='(('$regex1')|('$regex2')|('$regex3')|('$regex4'))'
finalregex='^[0-9a-f]+ '$regex'\.?$'

git -C "$source" log --oneline | grep -Eiv "$finalregex"
