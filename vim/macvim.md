# MacVim drawer

    git clone git://github.com/alloy/macvim.git
    cd macvim
    cd src
    ./configure --with-features=huge  \
                --enable-rubyinterp   \
                --enable-pythoninterp \
                --enable-cscope
               #--enable-perlinterp   \


    open MacVim/build/Release/MacVim.app
    open MacVim/build/Release

## ruby.h compilation problems

    1. Use system ruby
    2. comment out other rubies from path
    3. Enforce LDFLAGS.

       LDFLAGS=-L/usr/lib ./configure --with-features=huge \
              --enable-rubyinterp   \
              --enable-pythoninterp \
              --enable-perlinterp   \
              --enable-cscope

