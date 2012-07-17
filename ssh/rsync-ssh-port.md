# Rsync over ssh using custom port

    rsync -avhiP --rsh='ssh -p8023' \
          /path/to/dir user@host:target/dir
          