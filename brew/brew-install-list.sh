#!/bin/bash

file="./list-install.txt"

egrep -v "^#|^\s*$" ${file} |
while read keg
do
  printf "\n###\n### Install [${keg}]\n###\n"
  brew install ${keg}
  printf "\n\n\n"
done

# vim:ft=sh:

