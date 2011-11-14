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
# New Machine
#
VBoxManage createvm \
    --name $machine_name    \
    --ostype Linux26_64     \
    --register

#
# Server settings
#
VBoxManage modifyvm          \
    $machine_name            \
    --memory 256             \
    --vram       5           \
    --acpi       off         \
    --ioapic     on          \
    --pae        off         \
    --nestedpaging on        \
    --largepages   on        \
    --vtxvpid      on        \
    --cpus         2         \
    --rtcuseutc    on        \
    --monitorcount       1   \
    --accelerate3d       off \
    --accelerate2dvideo  off \
    --firmware bios              \
    --chipset  piix3             \
    --boot1    dvd               \
    --boot1    disk              \
    --boot3    none              \
    --boot4    none              \
    --nic1            nat        \
    --nictype1        82545EM    \
    --nic2            hostonly   \
    --cableconnected1 on         \
    --nicpromisc1     allow-vms  \
    --nictype2        82545EM    \
    --hostonlyadapter2 vboxnet0  \
    --cableconnected2 on         \
    --nicpromisc2     allow-vms  \
    --mouse    ps2        \
    --keyboard ps2        \
    --uart1    off        \
    --uart2    off        \
    --audio    none       \
    --usb      off        \
    --usbehci  off        \
    --vrde     off        \
    --teleporter off


#
# SATA disk: 20G
#
VBoxManage createhd         \
    --filename ${machine_dir}/${machine_name}/${machine_name}.vmdk  \
    --size   20480          \
    --format  VMDK          \
    --variant Standard

VBoxManage storagectl   \
    $machine_name       \
    --name "SATA Controller" \
    --add sata               \
    --controller IntelAhci   \
    --sataportcount 1        \
    --bootable on

VBoxManage storageattach            \
    $machine_name                   \
    --storagectl "SATA Controller"  \
    --port 0             \
    --type hdd --medium ${machine_dir}/${machine_name}/${machine_name}.vmdk

#
# DVD image to boot
#
VBoxManage storagectl       \
    $machine_name           \
    --name "IDE Controller" \
    --add ide               \
    --bootable on

VBoxManage storageattach            \
    $machine_name                   \
    --storagectl "IDE Controller"   \
    --device 1 --port 1             \
    --type dvddrive --medium "$dvd"



