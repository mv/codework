#!/bin/bash
#
# MacVim: my options (enabling perl)
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2009/09
#


DEST=/usr/local/macvim

# Ref:
#     http://code.google.com/p/macvim/wiki/Building?tm=4
#     git clone git://repo.or.cz/MacVim.git vim7
#
# Downloaded by build process:
#     http://download.damieng.com/latest/EnvyCodeR
#

cd ./src
set -e

make clean
#
PATH=/usr/bin:/bin ./configure \
    --with-features=huge    \
    --enable-gui=macvim     \
    --enable-perlinterp     \
    --enable-rubyinterp     \
    --enable-pythoninterp   \
    --enable-luainterp      \
    --enable-cscope         \
    --disable-workshop      \
    --disable-netbeans      \
    --disable-netbeans_intg \
         2>&1 | tee configure.my.log
    make 2>&1 | tee make.my.log

    cd MacVim && xcodebuild 2>&1 | tee xcodebuild.my.log

    # destination
    mkdir   -p  ${DEST}/bin

    # .app
    /bin/rm -rf ${DEST}/MacVim.app && /bin/cp -rp build/Release/MacVim.app ${DEST}/
    sudo ln -nsf ${DEST}/MacVim.app /Applications/

    # command line
    pwd
    /bin/cp -f MacVim/mvim ${DEST}/bin/
    for f in gview gvim gvimdiff gvimex mview mvim mvimdiff mvimex vi view vim vimdiff vimex
    do
       ln -nsf ${DEST}/bin/mvim /usr/local/bin/${f}
    done

# vim:ft=sh:

