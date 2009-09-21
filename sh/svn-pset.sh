#!/bin/bash
# $Id$
#
# cmdline: pset: list of files
# Set/2006
#

usage() {
cat <<CAT

    Usage: $0 <list.txt>

CAT
exit 2
}

[ ! -f "$1" ] && usage


for f in `cat $1`
do
    svn pset svn:keywords Id   "$f"
    svn pset svn:eol-stype LF  "$f"
done

