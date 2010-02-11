#!/usr/bin/env bash
#
# burn_iso_macos.sh
#     http://www.slashdotdash.net/2006/08/14/create-iso-cd-dvd-image-with-mac-os-x-tiger-10-4/
#     Marcus Vinicius Ferreira           ferreira.mv[ at ]gmail.com
#     Jan/2009
#

cat >&1 <<CAT

    drutil status                         # cd/dvd?
    diskutil unmountDisk /dev/disk1       # umount
    dd if=/dev/disk1 of=file.iso bs=2048  # copy
    hdid file.iso                         # test iso

CAT

