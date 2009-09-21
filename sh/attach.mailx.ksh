#!/bin/ksh

# -----------------------------------------------------------------------
# Filename:   mailx.ksh
# Purpose:    Demonstrates how one can attach files when sending E-Mail
#             messages from the Unix mailx utility.
# Author:     Frank Naude, Oracle FAQ
# -----------------------------------------------------------------------

SUBJECT="Send mail from Unix with file attachments"
TO=address\@domain.com
SPOOLFILE=/tmp/sqlplus.txt

echo "Produce listing from SQL*Plus..."
sqlplus -s scott/tiger >$SPOOLFILE <<-EOF
	set echo off feed off veri off pages 0 head off 
	select * from tab;
	EOF

# echo "Convert file to DOS mode..."
# unix2dos $SPOOLFILE $SPOOLFILE 2>/dev/null

echo "Send the E-mail message..."
/usr/bin/mailx -s "${SUBJECT}" ${TO} <<-EOF
	Hi,

	This sample E-mail message demonstrates how one can attach 
	files when sending messages with the Unix mailx utility.

	First attachment: SQL*Plus spool file
	~< ! uuencode $SPOOLFILE `basename $SPOOLFILE`

	Second attachment: mailx.ksh (this script)
	~< ! uuencode mailx.ksh mailx.txt

	Third attachment: /etc/passwd file
	~< ! uuencode /etc/passwd passwords

	Best regards

	~.
	EOF

echo "Done!"




