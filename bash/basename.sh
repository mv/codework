#!/bin/bash

set -x

# default
pathname="$1"
pathname=${pathname:='/mnt/public/upload/dump_2013-11-01.tar.gz'}

###
### delete on left: ltrim
###


# shortest
  pattern='/*/'
  one_level_relative_path=${pathname#${pattern}}

  pattern='*.'
  all_ext=${pathname#${pattern}}


# longest
  pattern='/*/'
  basename=${pathname##${pattern}}

  pattern='*.'
  one_ext=${pathname##${pattern}}


###
### delete on right: rtrim
###

# shortest
  pattern='/*/'
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
  onelevel_relpath=\${pathname#/*/}      ${pathname#*/}
          basename=\${pathname##/*/}     ${pathname##*/}

           all_ext=\${pathname#*.}       ${pathname#*.}
           one_ext=\${pathname##*.}      ${pathname##*.}

  # rtrim: shortest,longest (%,%%)
           dirname=\${pathname%/*/}      ${pathname%/*}
            nogzip=\${pathname%.*}       ${pathname%.*}
             noext=\${pathname%%.*}      ${pathname%%.*}

  basename: [${basename}]

            nogzip=\${basename%.*}       ${basename%.*}
             noext=\${basename%%.*}      ${basename%%.*}


  OReilly: Learning the Bash Shell
  ---------------------------------

     Expression                             Result
        \${path##/*/}                          long.file.name
        \${path#/*/}                  cam/book/long.file.name
        \$path                  /home/cam/book/long.file.name
        \${path%.*}             /home/cam/book/long.file
        \${path%%.*}            /home/cam/book/long

EOF

exit 0

