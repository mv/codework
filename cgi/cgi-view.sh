#!/bin/bash
#

##
## Remember:
##   - CGI is any program/script executed by the webserver
##   - webserver will pass information in 2 ways:
##       - using ENVIRONMENT variables
##       - using STDIN for POST/PUT methods, encoded
##   - in shell, 'GET' parameters must be handed by yourself
##   - in shell, 'POST' parameters must be handed by yourself
##   - in shell, 'POST' parameters are encoded.
##

PATH=/bin:/usr/bin:/sbin:/usr/sbin

printf "Content-type: text/html\n\n"

printf "<html><pre>\n\n"

echo "Environment"
echo "-----------"

env | sort | sed -e 's/=/ = /'

echo
echo "Method: ${REQUEST_METHOD}"
echo

if [ "$REQUEST_METHOD" == "POST" ] || \
   [ "$REQUEST_METHOD" == "PUT"  ]
then
    echo "Standard Input"
    echo "--------------"
    read -n $CONTENT_LENGTH QUERY_STRING_POST
    echo "$QUERY_STRING_POST"
    echo
fi

echo "</pre></html>"

# vim:ft=sh:

