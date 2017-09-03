#!/bin/bash
#
# MacVim: my options (enabling perl)
#
# Marcus Vinicius Ferreira                          ferreira.mv[ at ]gmail.com
# 2009/09
#


DEST=/usr/local/macvim-alloy

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
./configure \
    --with-features=huge    \
    --with-compiledby=Mv    \
    --with-macarchs=x86_64  \
    --enable-multibyte      \
    --enable-perlinterp     \
    --enable-rubyinterp     \
    --enable-pythoninterp   \
    --enable-luainterp      \
    --with-lua-prefix=/usr/local    \
    --enable-cscope         \
    --enable-gui=macvim     \
    --disable-workshop      \
    --disable-netbeans      \
         2>&1 | tee configure.my.log

#     --enable-tclinterp
#     --with-ruby-command=#{RUBY_PATH}
#     --with-tlib=ncurses     \

    make 2>&1 | tee make.my.log

    cd MacVim && xcodebuild 2>&1 | tee xcodebuild.my.log

    open build/Release/


# vim:ft=sh:

