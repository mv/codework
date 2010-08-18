#!/bin/bash
#
# Lorem Ipsum paragraphs
#
# Marcus Vinicius Ferreira                  ferreira.mv[ at ]gmail.com
# 2010/08
#

usage() {
    echo
    echo "Usage: $0 [paragraphs] "
    echo
    echo "    Get 'n' paragraphs of lorem ipsum text. Default=5."
    echo
    exit 2
}

qty=5
[ -z "$1" ] || qty="$1"

if ! lynx -source http://www.lipsum.com/feed/xml?amount=$qty|perl -p -i -e 's/\n/\n\n/g'|sed -n '/<lipsum>/,/<\/lipsum>/p'|sed -e 's/<[^>]*>//g'
then
    usage
fi

