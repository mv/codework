#!/bin/bash

usage() {
  echo
  echo "$0 /path/to/file.ext"
  echo
  exit 1
}

[ -z "$1" ] && usage

set -x
pathname="/mnt/public/upload/dump_2013-11-01.tar.gz"

###
### delete on left: ltrim
###


# shortest
  pattern='/'
  one_level_relative_path=${pathname#${pattern}}

  pattern='*.'
  all_ext=${pathname#${pattern}}

# longest
  pattern='*/'
  basename=${pathname##${pattern}}


  pattern='*.'
  one_ext=${pathname##${pattern}}


###
### delete on right: rtrim
###

# shortest
  pattern='/*'
  dirname=${pathname%${pattern}}

# longest
  pattern='.*'
  nogzip=${basename%${pattern}}


###
### cheat sheet
###

set +x
cat<<EOF

  pathname: [$pathname]

  # ltrim: shortest,longest (#,##)
  onelevel_relpath=\${pathname#*/}       ${pathname#*/}
          basename=\${pathname##*/}      ${pathname##*/}

           all_ext=\${pathname#*.}       ${pathname#*.}
           one_ext=\${pathname##*.}      ${pathname##*.}

  # rtrim: shortest,longest (%,%%)
           dirname=\${pathname%/*}       ${pathname%/*}
            nogzip=\${pathname%.*}       ${pathname%.*}
             noext=\${pathname%%.*}      ${pathname%%.*}

  basename: [${basename}]

            nogzip=\${basename%.*}       ${basename%.*}
             noext=\${basename%%.*}      ${basename%%.*}

EOF

exit 0

