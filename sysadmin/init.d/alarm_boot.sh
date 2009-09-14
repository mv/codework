#!/bin/bash
# $Id: alarm_boot.sh 6 2006-09-10 15:35:16Z marcus $
#

MAIL=/usr/local/exim/bin/exim
DEST=marcus_ferreira@yahoo.com


$MAIL $DEST <<MAIL
From: Administrator <admin@mvway.com>
To: Administrator <admin@mvway.com>
Subject: [`/bin/hostname`]: Recover from boot

System has booted.

Recover at: `/bin/date +%Y-%m-%d:%H:%M`

ifconfig:
`/sbin/ifconfig`

MAIL

