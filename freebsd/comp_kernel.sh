
-- $Id: comp_kernel.sh 6 2006-09-10 15:35:16Z marcus $

# cd /usr/src/i386/sys/conf

- edit conf file

# cd /usr/src
# make buildkernel KERNCONF=MYKERNEL
# make installkernel KERNCONF=MYKERNEL

