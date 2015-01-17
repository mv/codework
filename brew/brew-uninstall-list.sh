#!/bin/bash

file="./list-uninstall.txt"

egrep -v "^#|^\s*$" ${file} |
while read keg
do
  brew uninstall ${keg} --force
done

# vim:ft=sh:

