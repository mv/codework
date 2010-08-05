#!/bin/bash
#
# http://www.commandlinefu.com/commands/view/6226/download-a-file-securely-via-a-remote-ssh-server
#
# Marcus Vinicius Ferreira                  ferreira.mv[ at ]gmail.com
# 2010/Ago
#

[ -z "$1" ] && {
    echo
    echo "Usage: $0 <ssh_server> <ftp_url>"
    echo
    exit 1
}

server="$1"
  file="$2"

echo
echo "Wget [$file] ..."
echo

ssh $server "wget $file -O -" > $PWD/${file##*/}

