#!/bin/bash
#
# vbox-server-new.sh
#     VirtualBox: new server creation
#
# 2011/11
# Marcus Vinicius Ferreira               ferreira.mv[ at ]gmail.com
#

[ -z "$1" ] && {
    echo
    echo "Usage: $0 <machine_name>"
    echo
    exit 2
}

dvd="/pub/_iso/linux/CentOS-5.7-x86_64-bin-DVD/CentOS-5.7-x86_64-bin-DVD-1of2.iso"
machine_dir="/VMachine"
machine_name="$1"

#
# Server settings
#
VBoxManage modifyvm          \
    $machine_name            \
    --nic1             nat       \
    --natnet1          "10.0.2.0/24"   \
    --natbindip1       "10.0.2.16"     \
    --nictype1         82540EM   \
    --cableconnected1  on        \
    --nicpromisc1      deny \
    --nic2             hostonly  \
    --hostonlyadapter2 vboxnet0  \
    --nictype2         82540EM   \
    --cableconnected2  on        \
    --nicpromisc2      deny



