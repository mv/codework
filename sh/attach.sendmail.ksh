#!/bin/ksh

# --------------------------------------------------------------------
# Script:	unix_mail_withattachments.ksh
# Aurthor:	Ravin Maharaj
# Purpose:	Use sendmail to e-mail messages from Unix with 
#		file attachements
# --------------------------------------------------------------------

SUBJ="Send mail from Unix with file attachments"
TO=someone@domain_name
CC=someoneelse_1@domain_name,someoneelse_2@domain_name
(
cat << !
To : ${TO}
Subject : ${SUBJ}
Cc : ${CC}
!

cat << !
HOPE THIS WORKS
This sample E-mail message demonstrates how one can attach
files when sending messages with the Unix sendmail utility.
!

uuencode ${file_1}  ${file_1}
uuencode ${file_2}  ${file_2}
uuencode ${file_3}  ${file_3}
!

) | sendmail -v ${TO} ${CC}  


