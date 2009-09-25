#!/opt/bin/expect --

set password [lindex $argv 1]
spawn /bin/passwd [lindex $argv 0]
expect "Password:"
send "$password\r"
expect "Password:"
send "$password\r"
expect eof
set status [wait]
exit [lindex $status 3]



#!/bin/sh
# 
exec expect -f "$0" ${1+"$@"}
set password [lindex $argv 1]
spawn passwd [lindex $argv 0]
expect "assword:"
send "$password\r"
expect "assword:"
send "$password\r"
expect eof

#!/usr/bin/perl 
use Unix::PasswdFile;

$pw = new Unix::PasswdFile "/etc/passwd";
$pw->passwd("monk", $pw->encpass("My-New-Password"));
$pw->commit();
undef $pw;

