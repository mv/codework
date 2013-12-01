#!/bin/bash

usage() {
  echo
  echo "$0 /path/to/file.ext"
  echo
  exit 1
}

[ -z "$1" ] && usage

pathname="$1"

  relative_path=${pathname#*/}
  ltrim=${pathname#*marcus/}
      base_name=${pathname##*/}
        all_ext=${basename#*.}
            ext=${basename##*.}

      dirname=${pathname%/*}
     filename=${basename%%.*}


IFS=',' # to be use by '$*'
echo "\$#: $#"
echo "\$@: $@"
echo "\$*: $*"

# nvl
echo "-         nvl: \${varname:-test}:  ${varname:-test}   - \$varname: [$varname]"
echo "- set default: \${varname:=test}:  ${varname:=test}   - \$varname: [$varname]"
echo "-      exits?: \${varname:+true}:  ${varname:+true}   - \$varname: [$varname]"
echo "-   exception: \${varname:?msg}    ${varname:?'Exception: Must be defined!'}   - \$varname: [$varname]"
echo "-      substr: \${varname:0:2}     ${varname:0:2}     - \$varname: [$varname]"

