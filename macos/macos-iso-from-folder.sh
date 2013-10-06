#!/bin/bash
#

usage() {
  echo
  echo "Usage: $0 <folder>"
  echo
  echo "   Burns <folder> to folder.iso"
  echo
  exit 1
}

[ -z "$1" ] && usage
[ -d "$1" ] || usage

set -x
hdiutil makehybrid -iso -joliet -o "${1}.iso"  "$1"

# vim:ft=sh:

