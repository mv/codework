#!/bin/bash

usage () {
  echo "usage: $0 -d dir_name"
  echo any other helpful text
}

dirname=""
while getopts ":hd:" option; do
  case "$option" in
    d)  dirname="$OPTARG" ;;
    h)  # it's always useful to provide some help
        usage
        exit 0
        ;;
    :)  echo "Error: -$option requires an argument"
        usage
        exit 1
        ;;
    ?)  echo "Error: unknown option -$option"
        usage
        exit 1
        ;;
  esac
done

if [ -z "$dirname" ]; then
  echo "Error: you must specify a directory name using -d"
  usage
  exit 1
fi

if [ ! -d "$dirname" ]; then
  echo "Error: the dir_name argument must be a directory"
  exit 1
fi

# strip any trailing slash from the dir_name value
dirname="${dirname%/}"

