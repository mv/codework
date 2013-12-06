# MacVim drawer

    git clone git://github.com/alloy/macvim.git
    cd macvim
    cd src
    ./configure --with-features=huge  \
                --enable-cscope       \
                --enable-perlinterp   \
                --enable-rubyinterp   \
                --enable-pythoninterp \
                --enable-luainterp

    make

    # To test:
    open MacVim/build/Release/MacVim.app

    # To install: drag 'MacVim.app' to your location
    open MacVim/build/Release

##
## if ruby.h compilation problems
##

    1. Use system ruby
    2. comment out other rubies from path
    3. Enforce LDFLAGS.

       LDFLAGS=-L/usr/lib ./configure --with-features=huge \
              --enable-rubyinterp   \
              --enable-pythoninterp \
              --enable-perlinterp   \
              --enable-cscope

##
## if make error: src/os_unix.c (for build on Mac OS X 10.9 Mavericks)
##     Ref: https://groups.google.com/forum/#!topic/vim_dev/wGSyk59cDjw
##

    wget https://groups.google.com/group/vim_dev/attach/35ec989be91d045/os_unix.c.patch
    cd ../src/
    patch -p1 < os_unix.c.patch

