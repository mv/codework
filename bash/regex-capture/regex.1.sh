#!/bin/bash
#
# group episode files in a dir
#

move_to_dir() {
  dest="$1"
  file="$2"

  echo "Dir : [${dir_name}]"
  [ -d "${dest}" ] || mkdir "${dest}" ]
  /bin/mv "${file}"  "${dest}/${file}"
  echo
}

###
### Main
###

files="$( cat list.1.txt | grep -v txt )"
files="*.srt  *.mkv  *.mp?  *.avi  *.wmv"

regex="(.*)\.(S[0-9][0-9]E[0-9][0-9])"

for f in $files
do

  echo "File: [$f]"

  if [[ $f =~ $regex ]]
  then
    dir_name="${BASH_REMATCH[1]}"
    move_to_dir "${dir_name}"  "${f}"
  fi

done


