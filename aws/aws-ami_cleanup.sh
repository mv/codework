

egrep -v 'nologin|halt|sync|shutdown' /etc/passwd  | \
awk -F: '{print $6}' | while read dir
do

    # authorized_keys
    [ -d ${dir}/.ssh ] && /bin/rm -f ${dir}/.ssh/*

    # *history*
    for history in ${dir}/.*history*
    do
        rm -f ${history}
    done

done

# vim:ft=sh:
