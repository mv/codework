#!/bin/bash
#
# /etc/profile.d/setup_machine.sh:
#     export FACTER_setup_ variables
#
# Marcus Vinicius Fereira            ferreira.mv[ at ].gmail.com
# 2012-04
#

# break on '\n'
IFS='
'

# ignore comments and blank lines
for line in $( grep -v '^\s*#' /etc/setup/tags | grep -v "^\s*$" )
do

    # simple parser on 'key = value'
    # ltrim + rtrim for spaces and/or tabs
    key=$( echo $line | awk -F= '{ gsub( /^[ \t]* | [ \t]*$/ , "", $1 ) ; print $1 }' )
    val=$( echo $line | awk -F= '{ gsub( /^[ \t]* | [ \t]*$/ , "", $2 ) ; print $2 }' )

    # create new variable
    eval "export FACTER_tag_${key}=${val}"

done

# helpers
alias facts="env | sort | grep FACTER"
alias  tags="env | sort | grep FACTER_tag"

# vim:ft=sh:

