#!/bin/bash
#
# Remove from git history
#
#

gen() {
    echo git filter-branch --index-filter "git rm --cached --ignore-unmatch $1"
}


[ -z "$1" ] && {

echo
echo "Usage: $0 <pathname>"
echo
exit 1

}

gen "$1"

