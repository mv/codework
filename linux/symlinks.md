

## show invalid links


    find . -type l | (while read FN ; do test -e "$FN" || ls -d1 "$FN"; done)
    find . -type l | (while read FN ; do test -e "$FN" || ls -d1 "$FN"; done) | xargs rm


