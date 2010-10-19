#!/bin/bash - 
#
# 2010/10
#
# Ref: http://www.cyberciti.biz/tips/bash-shell-parameter-substitution-2.html

    # ${parameter:-defaultValue}      Get default shell variables value
    # ${parameter:=defaultValue}      Set default shell variables value
    # ${parameter:?"Error Message"}   Display an error message if parameter is not set

    # ${#var}                 Length of the string
    # ${var:num1:num2}        Substring
    # ${var/pattern/string}   Find and replace (only replace first occurrence)
    # ${var//pattern/string}  Find and replace all occurrences

    # ${var#pattern}   Remove from shortest front pattern
    # ${var##pattern}  Remove from longest  front pattern

    # ${var%pattern}   Remove from shortest rear (end) pattern
    # ${var%%pattern}  Remove from longest  rear (end) pattern


# Example
file="/etc/apache2/httpd.tar.gz"

echo "File: $file"
echo

echo "Remove from front #*/"
echo "    Simple: " ${file#*/}
echo "    Greedy: " ${file##*/}

echo

echo "Remove from rear  %.*"
echo "    Simple :" ${file%.*}
echo "    Greedy :" ${file%%.*}

echo


