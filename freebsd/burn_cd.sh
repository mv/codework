-- $Id: burn_cd.sh 6 2006-09-10 15:35:16Z marcus $


ISO Images to CD
----------------

burncd -f /dev/acd0c -v -e -s max data 5.3-RELEASE-i386-disc1.iso fixate

cdrecord -v dev=1,1,0 speed=4              -data 5.3-RELEASE-i386-disc1.iso
cdrecord -v dev=1,1,0 speed=8 fs=8m -dummy -data 5.3-RELEASE-i386-disc2.iso


cdrecord -v dev=1,1,0 speed=8 fs=8m -data FreeSBIE-1.1-i386.iso
