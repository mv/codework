#!/bin/bash
#
# MacVim: my options (enabling perl)
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2009/09
#


DEST=/usr/local/macvim


  # destination
  mkdir   -p  ${DEST}/bin

  # .app
  /bin/rm -rf ${DEST}/MacVim.app && /bin/cp -rp src/build/Release/MacVim.app ${DEST}/
  sudo ln -nf ${DEST}/MacVim.app /Applications/

  # command line
  pwd
  /bin/cp -f src/mvim ${DEST}/bin/
  for f in gview gvim gvimdiff gvimex mview mvim mvimdiff mvimex vi view vim vimdiff vimex
  do
     ln -nsf ${DEST}/bin/mvim /usr/local/bin/${f}
  done

# vim:ft=sh:

