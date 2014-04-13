#!/bin/bash
#

PATH=/bin:/usr/bin:/sbin:/usr/sbin

p() {
    echo "${@} </br>"
}

printf "Content-type: text/html\n\n"
printf "<html><code>\n"

p "Environment"
p "-----------"

# env | sort | column -t
env | sort | while read x
do p $x
done



if [ "$REQUEST_METHOD" == "POST" ] || \
   [ "$REQUEST_METHOD" == "PUT"  ]
then
    p "${REQUEST_METHOD}</br>"
    p "</br>"

    p "Standard Input"
    p "--------------"
    read -n $CONTENT_LENGTH QUERY_STRING_POST
    echo "[ $QUERY_STRING_POST ]"
    echo "$QUERY_STRING_POST"
    echo
fi

printf "</code></html>\n";

# vim:ft=sh:

