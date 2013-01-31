

# cygwin

    getfacl /cygdrive/d/KPL


    # one file
    getfacl /cygdrive/d/KPL | setfacl -f - Backup

    # dirtree
    for f in $( find . )
    do
        getfacl /cygdrive/d/KPL | setfacl -f - $f
    done


# linux

    for f in $( find . )
    do
        getfacl /cygdrive/d/KPL | setfacl --set-file=- $f
    done

