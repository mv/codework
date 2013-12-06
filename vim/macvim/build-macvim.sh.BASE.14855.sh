#!/bin/bash
#
# MacVim: my options (enabling perl)
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2009/09
#

DIR=/pub/src/macvim/
SRC=/pub/src/macvim/git-macvim/src

DEST=~/App/

# Ref:
#     http://code.google.com/p/macvim/wiki/Building?tm=4
#     git clone git://repo.or.cz/MacVim.git vim7
#
# Downloaded by build process:
#     http://download.damieng.com/latest/EnvyCodeR
#

[ -d $SRC ] || {
    printf "\nNot found src [$SRC]. Exitting...\n\n"
    exit 1
}

cd $SRC

make clean

PATH=/usr/bin:/bin ./configure \
    --enable-gui=macvim \
    --enable-perlinterp \
    --enable-rubyinterp \
    --disable-workshop  \
    --disable-netbeans  \
    --disable-netbeans_intg  \
    --enable-cscope     \
    2>&1 | tee configure.my.log
    \
    make            2>&1 | tee make.my.log          && \
    \
    cd MacVim && \
    xcodebuild      2>&1 | tee xcodebuild.my.log    && \
    open build/Release/MacVim.app

